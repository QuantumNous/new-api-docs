## Core Concepts

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API访问凭证，也指模型处理的文本单元 | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# OAuth Third-Party Login Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    Supports multiple OAuth login methods such as GitHub, OIDC, LinuxDO, WeChat, Telegram, etc. Implements CSRF protection and session management, supporting account binding and automatic registration. The frontend handles the OAuth flow via redirection.

## 🔐 No Authentication Required

### GitHub OAuth Redirection

- **Interface Name**：GitHub OAuth Redirection
- **HTTP Method**：GET
- **Path**：`/api/oauth/github`
- **Authentication Requirement**：Public
- **Function Description**：Handles GitHub OAuth callback to complete user login or account binding

💡 Request Example：

```
_// 前端通过重定向方式调用，通常由GitHub OAuth授权后自动回调  _window.location.href = `https://github.com/login/oauth/authorize?client_id=${github_client_id}&state=${state}&scope=user:email`;
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "github_user",  
      "display_name": "GitHub User",  
      "email": "user@example.com"  
    }  
  }  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "管理员未开启通过 GitHub 登录以及注册"  
}
```

🧾 Field Description：

- `code` (String): GitHub OAuth authorization code, provided by GitHub upon callback
- `state` (String): Anti-CSRF state code, must match the one stored in the session

### OIDC Generic OAuth Redirection

- **Interface Name**：OIDC Generic OAuth Redirection
- **HTTP Method**：GET
- **Path**：`/api/oauth/oidc`
- **Authentication Requirement**：Public
- **Function Description**：Handles OIDC OAuth callback, supporting generic OpenID Connect protocol login

💡 Request Example：

```
_// 前端通过重定向方式调用  _
const url = new URL(auth_url);  
url.searchParams.set('client_id', client_id);  
url.searchParams.set('redirect_uri', `${window.location.origin}/oauth/oidc`);  
url.searchParams.set('response_type', 'code');  
url.searchParams.set('scope', 'openid profile email');  
url.searchParams.set('state', state);  
window.location.href = url.toString();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "oidc_user",  
      "email": "user@example.com"  
    }  
  }  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "OIDC 获取用户信息失败！请检查设置！"  
}
```

🧾 Field Description：

- `code` (String): OIDC authorization code
- `state` (String): Anti-CSRF state code

### LinuxDo OAuth Redirection

- **Interface Name**：LinuxDo OAuth Redirection
- **HTTP Method**：GET
- **Path**：`/api/oauth/linuxdo`
- **Authentication Requirement**：Public
- **Function Description**：Handles LinuxDo OAuth callback, supporting login via LinuxDo community account

💡 Request Example：

```
_// 前端通过重定向方式调用  _
window.location.href = `https://connect.linux.do/oauth2/authorize?response_type=code&client_id=${linuxdo_client_id}&state=${state}`;
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "linuxdo_user",  
      "display_name": "LinuxDo User"  
    }  
  }  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "管理员关闭了新用户注册"  
}
```

🧾 Field Description：

- `code` (String): LinuxDo OAuth authorization code
- `state` (String): Anti-CSRF state code
- `error` (String): Optional, OAuth error code
- `error_description` (String): Optional, error description

### WeChat QR Code Login Redirection

- **Interface Name**：WeChat QR Code Login Redirection
- **HTTP Method**：GET
- **Path**：`/api/oauth/wechat`
- **Authentication Requirement**：Public
- **Function Description**：Handles WeChat QR code login, completing the login process via a verification code

💡 Request Example：

```
const response = await fetch(`/api/oauth/wechat?code=${wechat_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "wechat_user",  
      "wechat_id": "wechat_openid"  
    }  
  }  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "验证码无效或已过期"  
}
```

🧾 Field Description：

`code` (String): Verification code obtained from WeChat QR scan

### WeChat Account Binding

- **Interface Name**：WeChat Account Binding
- **HTTP Method**：GET
- **Path**：`/api/oauth/wechat/bind`
- **Authentication Requirement**：Public
- **Function Description**：Binds a WeChat account to an existing user account

💡 Request Example：

```
const response = await fetch(`/api/oauth/wechat/bind?code=${wechat_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "微信账户绑定成功！"  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "验证码无效或该微信账户已被绑定"  
}
```

🧾 Field Description：

`code` (String): Verification code obtained from WeChat QR scan

### Email Binding

- **Interface Name**：Email Binding
- **HTTP Method**：GET
- **Path**：`/api/oauth/email/bind`
- **Authentication Requirement**：Public
- **Function Description**：Binds an email address to a user account using an email verification code

💡 Request Example：

```
const response = await fetch(`/api/oauth/email/bind?email=${email}&code=${email_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "邮箱账户绑定成功！"  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "验证码无效或邮箱已被使用"  
}
```

🧾 Field Description：

- `email` (String): Email address to be bound
- `code` (String): Email verification code

### Telegram Login

- **Interface Name**：Telegram Login
- **HTTP Method**：GET
- **Path**：`/api/oauth/telegram/login`
- **Authentication Requirement**：Public
- **Function Description**：Completes user login via the Telegram Widget

💡 Request Example：

```
const params = {  
  id: telegram_user_id,  
  first_name: "John",  
  last_name: "Doe",   
  username: "johndoe",  
  photo_url: "https://...",  
  auth_date: 1640995200,  
  hash: "telegram_hash"  
};  
const query = new URLSearchParams(params).toString();
const response = await fetch(`/api/oauth/telegram/login?${query}`, {
  method: 'GET'
});
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "telegram_user",  
      "telegram_id": "123456789"  
    }  
  }  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "Telegram验证失败"  
}
```

🧾 Field Description：

- `id` (String): Telegram User ID
- `first_name` (String): User's first name
- `last_name` (String): User's last name, optional
- `username` (String): Telegram username, optional
- `photo_url` (String): Avatar URL, optional
- `auth_date` (Number): Authentication timestamp
- `hash` (String): Telegram verification hash

### Telegram Account Binding

- **Interface Name**：Telegram Account Binding
- **HTTP Method**：GET
- **Path**：`/api/oauth/telegram/bind`
- **Authentication Requirement**：Public
- **Function Description**：Binds a Telegram account to an existing user account

💡 Request Example：

```
// 通过TelegramLoginButton组件自动处理参数  
// 参数格式与Telegram登录相同  
const response = await fetch('/api/oauth/telegram/bind', {  
  method: 'GET',  
  params: telegram_auth_params  
});  
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "Telegram账户绑定成功！"  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "该Telegram账户已被绑定"  
}
```

🧾 Field Description：

Parameter format is the same as the Telegram login interface

### Get Random State (Anti-CSRF)

- **Interface Name**：Get Random State
- **HTTP Method**：GET
- **Path**：`/api/oauth/state`
- **Authentication Requirement**：Public
- **Function Description**：Generates a random state parameter for CSRF protection in the OAuth flow

💡 Request Example：

```
let path = '/api/oauth/state';  
let affCode = localStorage.getItem('aff');  
if (affCode && affCode.length > 0) {  
  path += `?aff=${affCode}`;  
}  
const response = await fetch(path, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "",  
  "data": "random_state_string_12chars"  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "生成state失败"  
}
```

🧾 Field Description：

- `aff` (String): Optional, referral code parameter, used to track user source
- `data` (String): The returned random state string, 12 characters long