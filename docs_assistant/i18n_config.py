"""
多语言配置模块
统一管理所有文本的多语言翻译
"""

class Language:
    """语言配置类"""
    def __init__(self, code, name, native_name):
        self.code = code
        self.name = name
        self.native_name = native_name

# 支持的语言列表
LANGUAGES = {
    'zh': Language('zh', 'Chinese', '中文'),
    'en': Language('en', 'English', 'English'),
    'ja': Language('ja', 'Japanese', '日本語')
}

# 文件路径配置
LANGUAGE_PATHS = {
    'zh': {
        'changelog': 'docs/wiki/changelog.md',
        'special_thanks': 'docs/wiki/special-thanks.md'
    },
    'en': {
        'changelog': 'docs/en/wiki/changelog.md',
        'special_thanks': 'docs/en/wiki/special-thanks.md'
    },
    'ja': {
        'changelog': 'docs/ja/wiki/changelog.md',
        'special_thanks': 'docs/ja/wiki/special-thanks.md'
    }
}

# Changelog 多语言文本
CHANGELOG_I18N = {
    'zh': {
        'title': '# 📝 更新日志',
        'warning_title': '版本日志信息 · 数据更新于',
        'warning_desc': '如需查看全部历史版本，请访问 [GitHub Releases 页面](https://github.com/{repo}/releases)，本页面从该页面定时获取最新更新信息。',
        'unknown_version': '未知版本',
        'no_release_notes': '无发布说明',
        'published_at': '发布于',
        'time_suffix': '(中国时间)',
        'latest_pre': '最新预发布版本',
        'latest': '最新正式版本',
        'pre': '预发布版本',
        'normal': '正式版本',
        'download_resources': '下载资源',
        'data_fetch_error': '无法获取发布数据',
        'no_data': '暂无版本数据，请稍后再试。',
        'update_failed': '更新更新日志失败'
    },
    'en': {
        'title': '# 📝 Changelog',
        'warning_title': 'Version Log Information · Data updated at',
        'warning_desc': 'To view all historical versions, please visit the [GitHub Releases page](https://github.com/{repo}/releases). This page automatically fetches the latest update information from that page.',
        'unknown_version': 'Unknown Version',
        'no_release_notes': 'No release notes',
        'published_at': 'Published at',
        'time_suffix': '(UTC+8)',
        'latest_pre': 'Latest Pre-release',
        'latest': 'Latest Release',
        'pre': 'Pre-release',
        'normal': 'Release',
        'download_resources': 'Download Resources',
        'data_fetch_error': 'Failed to fetch release data',
        'no_data': 'No version data available, please try again later.',
        'update_failed': 'Failed to update changelog'
    },
    'ja': {
        'title': '# 📝 変更履歴',
        'warning_title': 'バージョンログ情報 · データ更新日時',
        'warning_desc': 'すべての履歴バージョンを表示するには、[GitHub Releases ページ](https://github.com/{repo}/releases)をご覧ください。このページは定期的に最新の更新情報を取得します。',
        'unknown_version': '不明なバージョン',
        'no_release_notes': 'リリースノートなし',
        'published_at': '公開日',
        'time_suffix': '(UTC+8)',
        'latest_pre': '最新プレリリース版',
        'latest': '最新リリース版',
        'pre': 'プレリリース版',
        'normal': 'リリース版',
        'download_resources': 'Download Resources',
        'data_fetch_error': 'リリースデータの取得に失敗しました',
        'no_data': 'バージョンデータがありません。後でもう一度お試しください。',
        'update_failed': '変更履歴の更新に失敗しました'
    }
}

# Special Thanks 多语言文本
SPECIAL_THANKS_I18N = {
    'zh': {
        'title': '# 🙏 特别鸣谢',
        'intro': 'New API 的开发离不开社区的支持和贡献。在此特别感谢所有为项目提供帮助的个人和组织。',
        'sponsors_title': '## ❤️ 赞助商',
        'sponsors_intro': '以下是所有为项目提供资金支持的赞助商。感谢他们的慷慨捐助，让项目能够持续发展！',
        'sponsors_info_title': '赞助商信息 · 数据更新于',
        'sponsors_info_desc': '以下赞助商数据从爱发电平台自动获取。根据累计赞助金额，分为金牌、银牌和铜牌三个等级。如果您也想为项目提供资金支持，欢迎前往 [爱发电](https://afdian.com/a/new-api) 平台进行捐赠。',
        'contributors_title': '## 👨‍💻 开发贡献者',
        'contributors_intro': '以下是所有为项目做出贡献的开发者列表。在此感谢他们的辛勤工作和创意！',
        'contributors_info_title': '贡献者信息 · 数据更新于',
        'contributors_info_desc': '以下贡献者数据从 [GitHub Contributors 页面](https://github.com/Calcium-Ion/new-api/graphs/contributors) 自动获取前50名。贡献度前三名分别以金、银、铜牌边框标识。如果您也想为项目做出贡献，欢迎提交 Pull Request。',
        'contributions': '贡献次数',
        'total_sponsored': '累计赞助',
        'unknown_user': '未知用户',
        'anonymous_sponsor': '匿名赞助者',
        'no_contributor_data': '暂无贡献者数据，请稍后再试。',
        'no_sponsor_data': '暂无赞助商数据，请稍后再试。',
        'gold_sponsor': '金牌赞助商',
        'silver_sponsor': '银牌赞助商',
        'bronze_sponsor': '铜牌赞助商',
        'gold_sponsor_desc': '感谢以下金牌赞助商（赞助金额 ≥ 10001元）的慷慨支持！',
        'silver_sponsor_desc': '感谢以下银牌赞助商（赞助金额 1001-10000元）的慷慨支持！',
        'bronze_sponsor_desc': '感谢以下铜牌赞助商（赞助金额 0-1000元）的支持！',
        'data_fetch_error': '无法获取贡献者和赞助商数据',
        'update_failed': '更新贡献者列表失败'
    },
    'en': {
        'title': '# 🙏 Special Thanks',
        'intro': 'The development of New API would not be possible without the support and contributions of the community. We would like to express our special gratitude to all individuals and organizations who have helped with this project.',
        'sponsors_title': '## ❤️ Sponsors',
        'sponsors_intro': 'Below are all the sponsors who have provided financial support for the project. Thank you for their generous donations that allow the project to continue developing!',
        'sponsors_info_title': 'Sponsor Information · Data updated at',
        'sponsors_info_desc': 'The following sponsor data is automatically retrieved from the Afdian platform. Based on the cumulative sponsorship amount, they are divided into three levels: Gold, Silver, and Bronze. If you would also like to provide financial support for the project, you are welcome to make a donation on the [Afdian](https://afdian.com/a/new-api) platform.',
        'contributors_title': '## 👨‍💻 Developer Contributors',
        'contributors_intro': 'Below is a list of all developers who have contributed to the project. We thank them for their hard work and creativity!',
        'contributors_info_title': 'Contributor Information · Data updated at',
        'contributors_info_desc': 'The following contributor data is automatically retrieved from the [GitHub Contributors page](https://github.com/Calcium-Ion/new-api/graphs/contributors) for the top 50 contributors. The top three contributors are marked with gold, silver, and bronze borders respectively. If you would also like to contribute to the project, you are welcome to submit a Pull Request.',
        'contributions': 'Contributions',
        'total_sponsored': 'Total Sponsored',
        'unknown_user': 'Unknown User',
        'anonymous_sponsor': 'Anonymous Sponsor',
        'no_contributor_data': 'No contributor data available, please try again later.',
        'no_sponsor_data': 'No sponsor data available, please try again later.',
        'gold_sponsor': 'Gold Sponsors',
        'silver_sponsor': 'Silver Sponsors',
        'bronze_sponsor': 'Bronze Sponsors',
        'gold_sponsor_desc': 'Thank you to the following gold sponsors (sponsorship amount ≥ ¥10,001) for their generous support!',
        'silver_sponsor_desc': 'Thank you to the following silver sponsors (sponsorship amount ¥1,001-¥10,000) for their generous support!',
        'bronze_sponsor_desc': 'Thank you to the following bronze sponsors (sponsorship amount ¥0-¥1,000) for their support!',
        'data_fetch_error': 'Failed to fetch contributors and sponsors data',
        'update_failed': 'Failed to update contributors list'
    },
    'ja': {
        'title': '# 🙏 スペシャルサンクス',
        'intro': 'New API の開発は、コミュニティのサポートと貢献なしには実現できませんでした。プロジェクトに協力してくださったすべての個人と組織に特別な感謝を申し上げます。',
        'sponsors_title': '## ❤️ スポンサー',
        'sponsors_intro': '以下は、プロジェクトに財政的支援を提供してくださったすべてのスポンサーです。プロジェクトが継続的に発展できるよう、寛大な寄付をしてくださったことに感謝します！',
        'sponsors_info_title': 'スポンサー情報 · データ更新日時',
        'sponsors_info_desc': '以下のスポンサーデータは、Afdian プラットフォームから自動的に取得されます。累計スポンサー金額に基づいて、ゴールド、シルバー、ブロンズの3つのレベルに分類されます。プロジェクトに財政的支援を提供したい場合は、[Afdian](https://afdian.com/a/new-api) プラットフォームで寄付を歓迎します。',
        'contributors_title': '## 👨‍💻 開発貢献者',
        'contributors_intro': '以下は、プロジェクトに貢献してくださったすべての開発者のリストです。彼らの勤勉な作業と創造性に感謝します！',
        'contributors_info_title': '貢献者情報 · データ更新日時',
        'contributors_info_desc': '以下の貢献者データは、[GitHub Contributors ページ](https://github.com/Calcium-Ion/new-api/graphs/contributors)から上位50名を自動的に取得します。貢献度上位3名は、それぞれゴールド、シルバー、ブロンズの枠で識別されます。プロジェクトに貢献したい場合は、プルリクエストを送信してください。',
        'contributions': '貢献回数',
        'total_sponsored': '累計スポンサー',
        'unknown_user': '不明なユーザー',
        'anonymous_sponsor': '匿名スポンサー',
        'no_contributor_data': '貢献者データがありません。後でもう一度お試しください。',
        'no_sponsor_data': 'スポンサーデータがありません。後でもう一度お試しください。',
        'gold_sponsor': 'ゴールドスポンサー',
        'silver_sponsor': 'シルバースポンサー',
        'bronze_sponsor': 'ブロンズスポンサー',
        'gold_sponsor_desc': '以下のゴールドスポンサー（スポンサー金額 ≥ ¥10,001）の寛大なサポートに感謝します！',
        'silver_sponsor_desc': '以下のシルバースポンサー（スポンサー金額 ¥1,001-¥10,000）の寛大なサポートに感謝します！',
        'bronze_sponsor_desc': '以下のブロンズスポンサー（スポンサー金額 ¥0-¥1,000）のサポートに感謝します！',
        'data_fetch_error': '貢献者とスポンサーのデータの取得に失敗しました',
        'update_failed': '貢献者リストの更新に失敗しました'
    }
}

def get_text(category, key, lang='zh', **kwargs):
    """
    获取多语言文本
    
    Args:
        category: 分类 ('changelog' 或 'special_thanks')
        key: 文本键
        lang: 语言代码
        **kwargs: 格式化参数
    
    Returns:
        格式化后的文本
    """
    i18n_dict = CHANGELOG_I18N if category == 'changelog' else SPECIAL_THANKS_I18N
    text = i18n_dict.get(lang, i18n_dict['zh']).get(key, '')
    
    if kwargs:
        return text.format(**kwargs)
    return text

