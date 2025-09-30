# OAuth 第三方登录模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    支持 GitHub、OIDC、LinuxDO、微信、Telegram 等多种 OAuth 登录方式 。实现 CSRF 防护和会话管理，支持账户绑定和自动注册。前端通过重定向方式处理 OAuth 流程。

## 🔐 无需鉴权


### GitHub OAuth 跳转

- **接口名称**：GitHub OAuth 跳转
- **HTTP 方法**：GET
- **路径**：`/api/oauth/github`
- **鉴权要求**：公开
- **功能简介**：处理 GitHub OAuth 回调，完成用户登录或账户绑定

💡 请求示例：

```
_// 前端通过重定向方式调用，通常由GitHub OAuth授权后自动回调  _window.location.href = `https://github.com/login/oauth/authorize?client_id=${github_client_id}&state=${state}&scope=user:email`;
```

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "管理员未开启通过 GitHub 登录以及注册"  
}
```

🧾 字段说明：

- `code` （字符串）: GitHub OAuth 授权码，由 GitHub 回调时提供
- `state` （字符串）: 防 CSRF 状态码，必须与 session 中存储的一致

### OIDC 通用 OAuth 跳转

- **接口名称**：OIDC 通用 OAuth 跳转
- **HTTP 方法**：GET
- **路径**：`/api/oauth/oidc`
- **鉴权要求**：公开
- **功能简介**：处理 OIDC OAuth 回调，支持通用 OpenID Connect 协议登录

💡 请求示例：

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

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "OIDC 获取用户信息失败！请检查设置！"  
}
```

🧾 字段说明：

- `code` （字符串）: OIDC 授权码
- `state` （字符串）: 防 CSRF 状态码

### LinuxDo OAuth 跳转

- **接口名称**：LinuxDo OAuth 跳转
- **HTTP 方法**：GET
- **路径**：`/api/oauth/linuxdo`
- **鉴权要求**：公开
- **功能简介**：处理 LinuxDo OAuth 回调，支持通过 LinuxDo 社区账户登录

💡 请求示例：

```
_// 前端通过重定向方式调用  _
window.location.href = `https://connect.linux.do/oauth2/authorize?response_type=code&client_id=${linuxdo_client_id}&state=${state}`;
```

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "管理员关闭了新用户注册"  
}
```

🧾 字段说明：

- `code` （字符串）: LinuxDo OAuth 授权码
- `state` （字符串）: 防 CSRF 状态码
- `error` （字符串）: 可选，OAuth 错误码
- `error_description` （字符串）: 可选，错误描述

### 微信扫码登录跳转

- **接口名称**：微信扫码登录跳转
- **HTTP 方法**：GET
- **路径**：`/api/oauth/wechat`
- **鉴权要求**：公开
- **功能简介**：处理微信扫码登录，通过验证码完成登录流程

💡 请求示例：

```
const response = await fetch(`/api/oauth/wechat?code=${wechat_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "验证码无效或已过期"  
}
```

🧾 字段说明：

`code` （字符串）: 微信扫码获得的验证码

### 微信账户绑定

- **接口名称**：微信账户绑定
- **HTTP 方法**：GET
- **路径**：`/api/oauth/wechat/bind`
- **鉴权要求**：公开
- **功能简介**：将微信账户绑定到现有用户账户

💡 请求示例：

```
const response = await fetch(`/api/oauth/wechat/bind?code=${wechat_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "微信账户绑定成功！"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "验证码无效或该微信账户已被绑定"  
}
```

🧾 字段说明：

`code` （字符串）: 微信扫码获得的验证码

### 邮箱绑定

- **接口名称**：邮箱绑定
- **HTTP 方法**：GET
- **路径**：`/api/oauth/email/bind`
- **鉴权要求**：公开
- **功能简介**：通过邮箱验证码绑定邮箱到用户账户

💡 请求示例：

```
const response = await fetch(`/api/oauth/email/bind?email=${email}&code=${email_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "邮箱账户绑定成功！"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "验证码无效或邮箱已被使用"  
}
```

🧾 字段说明：

- `email` （字符串）: 要绑定的邮箱地址
- `code` （字符串）: 邮箱验证码

### Telegram 登录

- **接口名称**：Telegram 登录
- **HTTP 方法**：GET
- **路径**：`/api/oauth/telegram/login`
- **鉴权要求**：公开
- **功能简介**：通过 Telegram Widget 完成用户登录

💡 请求示例：

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

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "Telegram验证失败"  
}
```

🧾 字段说明：

- `id` （字符串）: Telegram 用户 ID
- `first_name` （字符串）: 用户名字
- `last_name` （字符串）: 用户姓氏，可选
- `username` （字符串）: Telegram 用户名，可选
- `photo_url` （字符串）: 头像 URL，可选
- `auth_date` （数字）: 认证时间戳
- `hash` （字符串）: Telegram 验证哈希

### Telegram 账户绑定

- **接口名称**：Telegram 账户绑定
- **HTTP 方法**：GET
- **路径**：`/api/oauth/telegram/bind`
- **鉴权要求**：公开
- **功能简介**：将 Telegram 账户绑定到现有用户账户

💡 请求示例：

```
// 通过TelegramLoginButton组件自动处理参数  
// 参数格式与Telegram登录相同  
const response = await fetch('/api/oauth/telegram/bind', {  
  method: 'GET',  
  params: telegram_auth_params  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "Telegram账户绑定成功！"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "该Telegram账户已被绑定"  
}
```

🧾 字段说明：

参数格式与 Telegram 登录接口相同

### 获取随机 state（防 CSRF）

- **接口名称**：获取随机 state
- **HTTP 方法**：GET
- **路径**：`/api/oauth/state`
- **鉴权要求**：公开
- **功能简介**：生成随机 state 参数用于 OAuth 流程的 CSRF 防护

💡 请求示例：

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

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "",  
  "data": "random_state_string_12chars"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "生成state失败"  
}
```

🧾 字段说明：

- `aff` （字符串）: 可选，推荐码参数，用于记录用户来源
- `data` （字符串）: 返回的随机 state 字符串，长度为 12 位
