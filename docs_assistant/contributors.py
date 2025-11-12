"""
贡献者和赞助商管理模块
自动获取 GitHub 贡献者和爱发电赞助商信息并生成特别鸣谢页面
"""

import os
import logging
from datetime import datetime
from github_api import fetch_github_data, GITHUB_REPO, GITHUB_PROXY, USE_PROXY
from afdian_api import fetch_afdian_sponsors
from utils import update_markdown_file, DOCS_DIR
from i18n_config import SPECIAL_THANKS_I18N, LANGUAGE_PATHS, get_text

logger = logging.getLogger('contributors')

# CSS 样式常量
CONTRIBUTOR_CSS = '''
<style>
.contributor-simple {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
}

.avatar-container {
    position: relative;
    margin-right: 15px;
}

.contributor-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
}

.medal-rank {
    position: absolute;
    bottom: -5px;
    right: -5px;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    font-size: 12px;
    color: white;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.rank-1 { background-color: #ffd700; }
.rank-2 { background-color: #c0c0c0; }
.rank-3 { background-color: #cd7f32; }

.gold-medal .contributor-avatar {
    border: 4px solid #ffd700;
    box-shadow: 0 0 10px #ffd700;
}

.silver-medal .contributor-avatar {
    border: 4px solid #c0c0c0;
    box-shadow: 0 0 10px #c0c0c0;
}

.bronze-medal .contributor-avatar {
    border: 4px solid #cd7f32;
    box-shadow: 0 0 10px #cd7f32;
}

.contributor-details {
    display: flex;
    flex-direction: column;
}

.contributor-details a {
    font-weight: 500;
    text-decoration: none;
}

.contributor-stats {
    font-size: 0.9rem;
    color: #666;
}

[data-md-color-scheme="slate"] .contributor-stats {
    color: #aaa;
}
</style>
'''

SPONSOR_CSS = '''
<style>
.sponsor-card {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
    padding: 15px;
    border-radius: 10px;
    background-color: rgba(0,0,0,0.03);
}

[data-md-color-scheme="slate"] .sponsor-card {
    background-color: rgba(255,255,255,0.05);
}

.sponsor-avatar-container {
    position: relative;
    margin-right: 20px;
}

.sponsor-avatar {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    object-fit: cover;
}

.sponsor-medal {
    position: absolute;
    bottom: -5px;
    right: -5px;
    padding: 3px 8px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: bold;
    color: white;
}

.gold-badge { background-color: #ffd700; color: #333; }
.silver-badge { background-color: #c0c0c0; color: #333; }
.bronze-badge { background-color: #cd7f32; color: white; }

.gold-sponsor .sponsor-avatar {
    border: 4px solid #ffd700;
    box-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
}

.silver-sponsor .sponsor-avatar {
    border: 4px solid #c0c0c0;
    box-shadow: 0 0 10px rgba(192, 192, 192, 0.5);
}

.sponsor-details {
    display: flex;
    flex-direction: column;
}

.sponsor-name {
    font-size: 1.2rem;
    font-weight: 600;
    margin-bottom: 5px;
}

.sponsor-amount {
    font-size: 0.9rem;
    color: #666;
}

[data-md-color-scheme="slate"] .sponsor-amount {
    color: #aaa;
}

.bronze-sponsors-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 15px;
}

.bronze-sponsor-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: 10px;
    border-radius: 8px;
    background-color: rgba(0,0,0,0.02);
}

[data-md-color-scheme="slate"] .bronze-sponsor-item {
    background-color: rgba(255,255,255,0.03);
}

.sponsor-avatar-small {
    width: 50px !important;
    height: 50px !important;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #cd7f32;
    margin-bottom: 8px;
}

.bronze-sponsor-name {
    font-size: 0.9rem;
    font-weight: 500;
    margin-bottom: 4px;
    word-break: break-word;
}

.bronze-sponsor-amount {
    font-size: 0.8rem;
    color: #666;
}

[data-md-color-scheme="slate"] .bronze-sponsor-amount {
    color: #aaa;
}
</style>
'''


def _get_medal_info(index):
    """获取奖牌信息"""
    medals = {
        0: ("gold-medal", '<span class="medal-rank rank-1">1</span>'),
        1: ("silver-medal", '<span class="medal-rank rank-2">2</span>'),
        2: ("bronze-medal", '<span class="medal-rank rank-3">3</span>')
    }
    return medals.get(index, ("", ""))


def _process_github_urls(avatar_url, profile_url):
    """处理GitHub URL，添加代理"""
    if USE_PROXY:
        if 'githubusercontent.com' in avatar_url:
            avatar_url = f'{GITHUB_PROXY}?url={avatar_url}'
        if 'github.com' in profile_url:
            profile_url = f'{GITHUB_PROXY}?url={profile_url}'
    return avatar_url, profile_url


def format_contributors_markdown(contributors_data, lang='zh'):
    """
    将贡献者数据格式化为Markdown内容
    
    Args:
        contributors_data: GitHub contributors 数据
        lang: 语言代码
    
    Returns:
        格式化后的 Markdown 字符串
    """
    if not contributors_data:
        return get_text('special_thanks', 'no_contributor_data', lang)
    
    i18n = SPECIAL_THANKS_I18N[lang]
    markdown = ""
    
    for index, contributor in enumerate(contributors_data):
        username = contributor.get('login', i18n['unknown_user'])
        avatar_url = contributor.get('avatar_url', '')
        profile_url = contributor.get('html_url', '')
        contributions = contributor.get('contributions', 0)
        
        # 处理URL
        avatar_url, profile_url = _process_github_urls(avatar_url, profile_url)
        
        # 获取奖牌信息
        medal_class, medal_label = _get_medal_info(index)
        
        # 生成贡献者卡片
        markdown += f'### {username}\n\n'
        markdown += f'<div class="contributor-simple {medal_class}">\n'
        markdown += f'  <div class="avatar-container">\n'
        markdown += f'    <img src="{avatar_url}" alt="{username}" class="contributor-avatar" />\n'
        if medal_label:
            markdown += f'    {medal_label}\n'
        markdown += f'  </div>\n'
        markdown += f'  <div class="contributor-details">\n'
        markdown += f'    <a href="{profile_url}" target="_blank">{username}</a>\n'
        markdown += f'    <span class="contributor-stats">{i18n["contributions"]}: {contributions}</span>\n'
        markdown += f'  </div>\n'
        markdown += f'</div>\n\n'
        markdown += '---\n\n'
    
    markdown += CONTRIBUTOR_CSS
    return markdown


def format_sponsors_markdown(sponsors_data, lang='zh'):
    """
    将赞助商数据格式化为Markdown内容
    
    Args:
        sponsors_data: 赞助商数据
        lang: 语言代码
    
    Returns:
        格式化后的 Markdown 字符串
    """
    if not sponsors_data:
        return get_text('special_thanks', 'no_sponsor_data', lang)
    
    i18n = SPECIAL_THANKS_I18N[lang]
    
    # 赞助商等级配置
    sponsor_levels = {
        'gold': {
            'emoji': '🥇',
            'title': i18n['gold_sponsor'],
            'desc': i18n['gold_sponsor_desc'],
            'use_grid': False
        },
        'silver': {
            'emoji': '🥈',
            'title': i18n['silver_sponsor'],
            'desc': i18n['silver_sponsor_desc'],
            'use_grid': False
        },
        'bronze': {
            'emoji': '🥉',
            'title': i18n['bronze_sponsor'],
            'desc': i18n['bronze_sponsor_desc'],
            'use_grid': True
        }
    }
    
    markdown = ""
    
    for level, config in sponsor_levels.items():
        sponsors = sponsors_data.get(level, [])
        if not sponsors:
            continue
        
        markdown += f"### {config['emoji']} {config['title']}\n\n"
        markdown += f"{config['desc']}\n\n"
        
        if config['use_grid']:
            # 铜牌赞助商使用网格布局
            markdown += '<div class="bronze-sponsors-grid">\n'
            for sponsor in sponsors:
                name = sponsor.get('name', i18n['anonymous_sponsor'])
                avatar = sponsor.get('avatar', '')
                amount = sponsor.get('amount', 0)
                markdown += f'  <div class="bronze-sponsor-item">\n'
                markdown += f'    <img src="{avatar}" alt="{name}" class="sponsor-avatar-small" />\n'
                markdown += f'    <span class="bronze-sponsor-name">{name}</span>\n'
                markdown += f'    <span class="bronze-sponsor-amount">¥{amount:.2f}</span>\n'
                markdown += f'  </div>\n'
            markdown += '</div>\n\n'
        else:
            # 金牌和银牌赞助商使用卡片布局
            for sponsor in sponsors:
                name = sponsor.get('name', i18n['anonymous_sponsor'])
                avatar = sponsor.get('avatar', '')
                amount = sponsor.get('amount', 0)
                
                markdown += f'<div class="sponsor-card {level}-sponsor">\n'
                markdown += f'  <div class="sponsor-avatar-container">\n'
                markdown += f'    <img src="{avatar}" alt="{name}" class="sponsor-avatar" />\n'
                markdown += f'    <span class="sponsor-medal {level}-badge">{level.capitalize()}</span>\n'
                markdown += f'  </div>\n'
                markdown += f'  <div class="sponsor-details">\n'
                markdown += f'    <span class="sponsor-name">{name}</span>\n'
                markdown += f'    <span class="sponsor-amount">{i18n["total_sponsored"]}: ¥{amount:.2f}</span>\n'
                markdown += f'  </div>\n'
                markdown += f'</div>\n\n'
        
        markdown += '---\n\n'
    
    markdown += SPONSOR_CSS
    return markdown


def _generate_special_thanks_content(contributors_data, contributors_success, 
                                     sponsors_data, sponsors_success, lang):
    """生成特别感谢页面内容"""
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    i18n = SPECIAL_THANKS_I18N[lang]
    content_parts = [f"{i18n['title']}\n\n{i18n['intro']}\n\n"]
    
    if sponsors_success and sponsors_data:
        content_parts.append(f"""{i18n['sponsors_title']}

{i18n['sponsors_intro']}

!!! info "{i18n['sponsors_info_title']} {current_time} (UTC+8)"
    {i18n['sponsors_info_desc']}

{format_sponsors_markdown(sponsors_data, lang)}
""")
    
    if contributors_success and contributors_data:
        content_parts.append(f"""{i18n['contributors_title']}

{i18n['contributors_intro']}

!!! info "{i18n['contributors_info_title']} {current_time} (UTC+8)"
    {i18n['contributors_info_desc']}

{format_contributors_markdown(contributors_data, lang)}
""")
    
    return ''.join(content_parts)


def update_special_thanks_all_langs():
    """更新所有语言版本的特别感谢文件"""
    try:
        contributors_data, contributors_success = fetch_github_data(GITHUB_REPO, "contributors", 50)
        sponsors_data, sponsors_success = fetch_afdian_sponsors()
        
        if not contributors_success and not sponsors_success:
            logger.error("贡献者和赞助商数据获取均失败")
            return False
        
        all_success = True
        for lang in ['zh', 'en', 'ja']:
            try:
                full_content = _generate_special_thanks_content(
                    contributors_data, contributors_success,
                    sponsors_data, sponsors_success, lang
                )
                
                file_path = LANGUAGE_PATHS[lang]['special_thanks']
                thanks_file = os.path.join(DOCS_DIR, file_path)
                
                if not update_markdown_file(thanks_file, full_content):
                    all_success = False
                    
            except Exception as e:
                logger.error(f"特别感谢文件（{lang}）更新异常: {str(e)}")
                all_success = False
        
        return all_success
    
    except Exception as e:
        logger.error(f"批量更新特别感谢文件失败: {str(e)}")
        return False


def update_special_thanks_file(lang='zh'):
    """
    更新特别感谢文件
    
    Args:
        lang: 语言代码
    
    Returns:
        bool: 更新是否成功
    """
    try:
        contributors_data, contributors_success = fetch_github_data(GITHUB_REPO, "contributors", 50)
        sponsors_data, sponsors_success = fetch_afdian_sponsors()
        
        if not contributors_success and not sponsors_success:
            logger.error(get_text('special_thanks', 'data_fetch_error', lang))
            return False
        
        full_content = _generate_special_thanks_content(
            contributors_data, contributors_success,
            sponsors_data, sponsors_success, lang
        )
        
        file_path = LANGUAGE_PATHS[lang]['special_thanks']
        thanks_file = os.path.join(DOCS_DIR, file_path)
        return update_markdown_file(thanks_file, full_content)
    
    except Exception as e:
        logger.error(f"{get_text('special_thanks', 'update_failed', lang)}: {str(e)}")
        return False
