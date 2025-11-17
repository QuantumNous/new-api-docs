import os
import time
import requests
import logging
from datetime import datetime

# 环境变量配置
GITHUB_REPO = os.environ.get('GITHUB_REPO', 'QuantumNous/new-api')
GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN', '')  # GitHub Personal Access Token
GITHUB_PROXY = os.environ.get('GITHUB_PROXY', '')
USE_PROXY = os.environ.get('USE_PROXY', 'false').lower() == 'false'

# GitHub API限制相关参数
MAX_RETRY_ATTEMPTS = 3
RATE_LIMIT_WAIT_TIME = 60  # 触发限制后等待的秒数
MIN_REMAINING_CALLS = 10  # 剩余调用次数阈值，低于此值将等待

logger = logging.getLogger('github-api')

def _get_headers():
    """获取请求头，如果有 Token 则添加认证"""
    headers = {'User-Agent': 'Mozilla/5.0 DocUpdater/1.0'}
    if GITHUB_TOKEN:
        headers['Authorization'] = f'token {GITHUB_TOKEN}'
        logger.debug("使用 GitHub Token 进行认证")
    else:
        logger.warning("未配置 GitHub Token，API 限制为 60次/小时。建议设置 GITHUB_TOKEN 环境变量提升至 5000次/小时")
    return headers


def _check_rate_limit(headers):
    """
    检查 GitHub API 速率限制状态
    
    Returns:
        tuple: (是否需要等待, 等待时间秒数)
    """
    try:
        response = requests.get('https://api.github.com/rate_limit', headers=headers, timeout=10)
        if response.status_code == 200:
            rate_data = response.json()
            core = rate_data.get('rate', {})
            remaining = core.get('remaining', 0)
            reset_time = core.get('reset', 0)
            limit = core.get('limit', 60)
            
            logger.info(f"GitHub API 配额: 剩余 {remaining}/{limit} 次，重置时间: {datetime.fromtimestamp(reset_time).strftime('%H:%M:%S')}")
            
            # 如果剩余次数过低，计算等待时间
            if remaining < MIN_REMAINING_CALLS:
                wait_time = max(reset_time - time.time() + 5, 0)  # 加5秒缓冲
                if wait_time > 0:
                    logger.warning(f"API 配额不足 ({remaining} < {MIN_REMAINING_CALLS})，需等待 {wait_time:.0f} 秒")
                    return True, wait_time
            
            return False, 0
    except Exception as e:
        logger.warning(f"无法检查速率限制: {str(e)}")
        return False, 0


def fetch_github_data(repo, data_type, count, use_proxy=True):
    """获取GitHub数据，智能处理API限制"""
    logger.info(f"获取GitHub数据: {repo}, {data_type}, count={count}")
    
    headers = _get_headers()
    
    # 检查速率限制
    need_wait, wait_time = _check_rate_limit(headers)
    if need_wait:
        logger.info(f"等待 API 配额恢复 ({wait_time:.0f} 秒)...")
        time.sleep(wait_time)
    
    for attempt in range(MAX_RETRY_ATTEMPTS):
        try:
            # 构建API路径
            if data_type == "releases":
                api_path = f'repos/{repo}/releases?per_page={count}'
            elif data_type == "contributors":
                api_path = f'repos/{repo}/contributors?per_page={count}'
            else:
                return None, False
            
            # 构建API URL
            if use_proxy and USE_PROXY and GITHUB_PROXY:
                original_api_url = f'https://api.github.com/{api_path}'
                api_url = f'{GITHUB_PROXY}?url={original_api_url}'
                logger.debug(f"使用代理: {GITHUB_PROXY}")
            else:
                api_url = f'https://api.github.com/{api_path}'
            
            # 发送请求
            response = requests.get(api_url, headers=headers, timeout=30)
            
            # 记录响应头中的速率限制信息
            if 'X-RateLimit-Remaining' in response.headers:
                remaining = response.headers.get('X-RateLimit-Remaining')
                limit = response.headers.get('X-RateLimit-Limit')
                logger.debug(f"本次请求后剩余: {remaining}/{limit}")
            
            # 检查API限制
            if response.status_code == 403:
                error_message = response.text.lower()
                if 'rate limit exceeded' in error_message or 'api rate limit' in error_message:
                    reset_time = response.headers.get('X-RateLimit-Reset')
                    if reset_time:
                        wait_until = int(reset_time) - int(time.time()) + 5
                        logger.warning(f"GitHub API限制已达到，需等待 {wait_until} 秒后重置")
                        if wait_until > 0 and wait_until < 3600:  # 最多等待1小时
                            time.sleep(wait_until)
                            continue
                    else:
                        logger.warning(f"GitHub API限制已达到，等待{RATE_LIMIT_WAIT_TIME}秒后重试...")
                        time.sleep(RATE_LIMIT_WAIT_TIME)
                        continue
                
            response.raise_for_status()
            data = response.json()
            
            # 处理分页 (仅适用于贡献者数据)
            if data_type == "contributors" and len(data) < count and len(data) > 0:
                all_data = data.copy()
                page = 2
                
                # 最多获取3页，避免触发API限制
                while len(all_data) < count and page <= 3:
                    # 等待2秒避免请求过快
                    time.sleep(2)
                    
                    # 构建下一页URL
                    next_api_url = f'{api_path}&page={page}'
                    if use_proxy and USE_PROXY and GITHUB_PROXY:
                        next_url = f'{GITHUB_PROXY}?url=https://api.github.com/{next_api_url}'
                    else:
                        next_url = f'https://api.github.com/{next_api_url}'
                    
                    next_response = requests.get(next_url, headers=headers, timeout=30)
                    
                    # 检查速率限制
                    if next_response.status_code == 403:
                        logger.warning("分页请求遇到速率限制，停止获取更多数据")
                        break
                    
                    next_response.raise_for_status()
                    next_data = next_response.json()
                    
                    if not next_data:
                        break
                        
                    all_data.extend(next_data)
                    page += 1
                
                return all_data[:count], True
            
            return data, True
            
        except requests.exceptions.RequestException as e:
            logger.error(f"API请求失败 (尝试 {attempt+1}/{MAX_RETRY_ATTEMPTS}): {str(e)}")
            
            # 如果代理失败，尝试直接访问
            if use_proxy and USE_PROXY and GITHUB_PROXY and attempt == 0:
                logger.info("代理请求失败，尝试直接访问 GitHub API")
                return fetch_github_data(repo, data_type, count, False)
            
            # 等待后重试，使用指数退避
            wait_time = 5 * (2 ** attempt)  # 5, 10, 20 秒
            logger.info(f"等待 {wait_time} 秒后重试...")
            time.sleep(wait_time)
            
    logger.error(f"在{MAX_RETRY_ATTEMPTS}次尝试后获取数据失败")
    return None, False


def get_rate_limit_status():
    """
    获取当前的 API 速率限制状态
    
    Returns:
        dict: 包含 limit, remaining, reset 等信息
    """
    headers = _get_headers()
    try:
        response = requests.get('https://api.github.com/rate_limit', headers=headers, timeout=10)
        if response.status_code == 200:
            return response.json().get('rate', {})
    except Exception as e:
        logger.error(f"获取速率限制状态失败: {str(e)}")
    return {}