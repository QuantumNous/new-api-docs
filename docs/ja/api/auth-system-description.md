## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス資格情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# 認証システムの説明（Auth）

!!! info "説明"
    システムは四段階の認証メカニズムを採用しています：公開、ユーザー、管理者、Root

## 🔐 認証

- 公開：ログイン不要
- ユーザー：ユーザー トークンが必要 （middleware.UserAuth）
- 管理者：管理者 トークンが必要 （middleware.AdminAuth）
- Root：最高権限ユーザーのみ （middleware.RootAuth）