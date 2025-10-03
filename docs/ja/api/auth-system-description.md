# 認証システムの説明（Auth）

!!! info "説明"
    システムは、公開、ユーザー、管理者、Rootの4段階の認証メカニズムを採用しています。

## 🔐 認証

- 公開：ログイン不要
- ユーザー：ユーザー トークンが必要（middleware.UserAuth）
- 管理者：管理者 トークンが必要（middleware.AdminAuth）
- Root：最高権限ユーザーのみ（middleware.RootAuth）