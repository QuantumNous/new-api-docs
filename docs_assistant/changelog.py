"""
更新日志生成模块
自动从 GitHub Releases 获取版本信息并生成更新日志
"""

import os
import re
import logging
from datetime import datetime, timezone, timedelta
from github_api import fetch_github_data, GITHUB_REPO, GITHUB_PROXY, USE_PROXY
from utils import update_markdown_file, format_file_size, DOCS_DIR
from i18n_config import CHANGELOG_I18N, LANGUAGE_PATHS, get_text

logger = logging.getLogger('changelog')


def _format_time_to_china_time(published_at, lang='zh'):
    """格式化时间为中国时间"""
    if not published_at:
        return get_text('changelog', 'unknown_version', lang)
    
    try:
        pub_date = datetime.fromisoformat(published_at.replace('Z', '+00:00'))
        china_date = pub_date.replace(tzinfo=timezone.utc).astimezone(timezone(timedelta(hours=8)))
        time_suffix = get_text('changelog', 'time_suffix', lang)
        return f"{china_date.strftime('%Y-%m-%d %H:%M:%S')} {time_suffix}"
    except Exception:
        return published_at


def _process_markdown_headers(body):
    """处理Markdown格式标题级别，降低标题级别"""
    if not isinstance(body, str):
        return body
    
    # 从高级别到低级别处理，避免多次降级
    body = re.sub(r'^######\s+', '###### ', body, flags=re.MULTILINE)
    body = re.sub(r'^#####\s+', '###### ', body, flags=re.MULTILINE)
    body = re.sub(r'^####\s+', '##### ', body, flags=re.MULTILINE)
    body = re.sub(r'^###\s+', '#### ', body, flags=re.MULTILINE)
    body = re.sub(r'^##\s+', '### ', body, flags=re.MULTILINE)
    body = re.sub(r'^#\s+', '### ', body, flags=re.MULTILINE)
    return body


def _process_image_links(body):
    """处理图片链接代理"""
    if not USE_PROXY or not isinstance(body, str):
        return body
    
    # 替换Markdown格式的图片链接
    body = re.sub(r'!\[(.*?)\]\((https?://[^)]+)\)', 
                  f'![\g<1>]({GITHUB_PROXY}?url=\\2)', body)
    
    # 替换HTML格式的图片链接
    body = re.sub(r'<img([^>]*)src="(https?://[^"]+)"([^>]*)>', 
                  f'<img\\1src="{GITHUB_PROXY}?url=\\2"\\3>', body)
    
    return body


def _format_download_links(tag_name, assets, lang='zh'):
    """格式化下载链接"""
    if not assets and not tag_name:
        return ""
    
    download_text = get_text('changelog', 'download_resources', lang)
    markdown = f'    **{download_text}**\n\n'
    
    # 添加资源文件
    for asset in assets:
        name = asset.get('name', '')
        url = asset.get('browser_download_url', '')
        if USE_PROXY and 'github.com' in url:
            url = f'{GITHUB_PROXY}?url={url}'
        size = format_file_size(asset.get('size', 0))
        markdown += f'    - [{name}]({url}) ({size})\n'
    
    # 添加源代码下载链接
    if tag_name:
        for ext, ext_name in [('zip', 'zip'), ('tar.gz', 'tar.gz')]:
            url = f'https://github.com/{GITHUB_REPO}/archive/refs/tags/{tag_name}.{ext}'
            if USE_PROXY:
                url = f'{GITHUB_PROXY}?url={url}'
            markdown += f'    - [Source code ({ext_name})]({url})\n'
    
    markdown += '\n'
    return markdown


def _ensure_string_field(value, default=''):
    """确保字段是字符串类型"""
    return value if isinstance(value, str) else default


def _get_version_type(index, prerelease, lang='zh'):
    """获取版本类型文本"""
    if index == 0:
        key = 'latest_pre' if prerelease else 'latest'
    else:
        key = 'pre' if prerelease else 'normal'
    
    return get_text('changelog', key, lang)


def format_releases_markdown(releases_data, lang='zh'):
    """
    将发布数据格式化为Markdown内容
    
    Args:
        releases_data: GitHub releases 数据
        lang: 语言代码 ('zh', 'en', 'ja')
    
    Returns:
        格式化后的 Markdown 字符串
    """
    if not releases_data:
        return get_text('changelog', 'no_data', lang)
    
    i18n = CHANGELOG_I18N[lang]
    markdown = f"{i18n['title']}\n\n"
    
    # 添加警告信息
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    time_suffix = i18n['time_suffix']
    warning_desc = i18n['warning_desc'].format(repo=GITHUB_REPO)
    
    markdown += f"!!! warning \"{i18n['warning_title']} {current_time} {time_suffix}\"\n"
    markdown += f"    {warning_desc}\n\n"
    
    # 处理每个版本
    for index, release in enumerate(releases_data):
        # 提取并确保所有字段都是字符串
        tag_name = _ensure_string_field(release.get('tag_name'), i18n['unknown_version'])
        name = _ensure_string_field(release.get('name'), tag_name)
        published_at = _ensure_string_field(release.get('published_at'))
        body = _ensure_string_field(release.get('body'), i18n['no_release_notes'])
        prerelease = release.get('prerelease', False)
        
        # 处理内容
        formatted_date = _format_time_to_china_time(published_at, lang)
        body = _process_markdown_headers(body)
        body = _process_image_links(body)
        
        # 生成版本块
        markdown += f'## {name}\n\n'
        
        version_type = _get_version_type(index, prerelease, lang)
        admonition_type = "success" if index == 0 else "info"
        
        markdown += f'???+ {admonition_type} "{version_type} · {i18n["published_at"]} {formatted_date}"\n\n'
        
        # 缩进内容
        indented_body = '\n'.join(['    ' + line for line in body.split('\n')])
        markdown += f'{indented_body}\n\n'
        
        # 添加下载链接
        assets = release.get('assets', [])
        download_links = _format_download_links(tag_name, assets, lang)
        if download_links:
            markdown += download_links
        
        markdown += '---\n\n'
    
    return markdown


def update_changelog_file(lang='zh'):
    """
    更新更新日志文件
    
    Args:
        lang: 语言代码 ('zh', 'en', 'ja')
    
    Returns:
        bool: 更新是否成功
    """
    try:
        # 获取发布数据
        releases_data, success = fetch_github_data(GITHUB_REPO, "releases", 30)
        if not success or not releases_data:
            logger.error(get_text('changelog', 'data_fetch_error', lang))
            return False
        
        # 格式化为Markdown
        releases_markdown = format_releases_markdown(releases_data, lang)
        
        # 更新文件
        file_path = LANGUAGE_PATHS[lang]['changelog']
        changelog_file = os.path.join(DOCS_DIR, file_path)
        return update_markdown_file(changelog_file, releases_markdown)
    
    except Exception as e:
        error_msg = f"{get_text('changelog', 'update_failed', lang)}: {str(e)}"
        logger.error(error_msg)
        return False


# 便捷函数
def update_changelog_file_en():
    """更新更新日志文件（英文版）"""
    return update_changelog_file('en')


def update_changelog_file_ja():
    """更新更新日志文件（日文版）"""
    return update_changelog_file('ja')
