# 鉴权体系说明（Auth）

!!! info "说明"
    系统采用四级鉴权机制：公开、用户、管理员、Root
    AccessToken 为您 **在个人设置-系统访问令牌** 中生成的用于 **/api** 路由 访问的令牌

## 🔐 鉴权

- 公开：无需登录
- 用户：需要用户 AccessToken （middleware.UserAuth）
- 管理员：需要管理员 AccessToken （middleware.AdminAuth）
- Root：仅限最高权限用户 AccessToken （middleware.RootAuth）