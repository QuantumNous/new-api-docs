# Authentication System Description (Auth)

!!! info "Note"
    The system uses a four-level authentication mechanism: Public, User, Admin, Root

## 🔐 Authentication

- Public: No login required
- User: Requires User Token (middleware.UserAuth)
- Admin: Requires Admin Token (middleware.AdminAuth)
- Root: Restricted to users with the highest privileges (middleware.RootAuth)