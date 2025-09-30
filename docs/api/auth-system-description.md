# 鉴权体系说明（Auth）

!!! info "说明"
    系统采用四级鉴权机制：公开、用户、管理员、Root

## 🔐 鉴权

- 公开：无需登录
- 用户：需要用户 Token （middleware.UserAuth）
- 管理员：需要管理员 Token （middleware.AdminAuth）
- Root：仅限最高权限用户 （middleware.RootAuth）