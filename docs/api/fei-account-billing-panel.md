# 账户计费面板模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    OpenAI SDK 兼容的计费查询接口 。使用 Token 认证，提供订阅信息和使用量查询。主要用于第三方应用和 SDK 集成，确保与 OpenAI API 的完全兼容性。

## 🔐 用户鉴权

### 获取订阅额度信息

- **接口名称**：获取订阅额度信息
- **HTTP 方法**：GET
- **路径**：`/dashboard/billing/subscription`
- **鉴权要求**：用户 Token
- **功能简介**：获取用户的订阅配额信息，包括总额度、硬限制和访问有效期，兼容 OpenAI API 格式 

💡 请求示例：

```
const response = await fetch('/dashboard/billing/subscription', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "object": "billing_subscription",  
  "has_payment_method": true,  
  "soft_limit_usd": 100.0,  
  "hard_limit_usd": 100.0,  
  "system_hard_limit_usd": 100.0,  
  "access_until": 1640995200  
}
```

❗ 失败响应示例：

```
{  
  "error": {  
    "message": "获取配额失败",  
    "type": "upstream_error"  
  }  
}
```

🧾 字段说明：

- `object` （字符串）: 固定值"billing_subscription"
- `has_payment_method` （布尔型）: 是否有支付方式，固定为 true 
- `soft_limit_usd` （数字）: 软限制额度（美元）
- `hard_limit_usd` （数字）: 硬限制额度（美元）
- `system_hard_limit_usd` （数字）: 系统硬限制额度（美元）
- `access_until` （数字）: 访问有效期时间戳，Token 过期时间 

### 兼容 OpenAI SDK 路径 - 获取订阅额度信息

- **接口名称**：兼容 OpenAI SDK 路径 - 获取订阅额度信息
- **HTTP 方法**：GET
- **路径**：`/v1/dashboard/billing/subscription`
- **鉴权要求**：用户 Token
- **功能简介**：与上述接口功能完全相同，提供 OpenAI SDK 兼容路径

💡 请求示例：

```
const response = await fetch('/v1/dashboard/billing/subscription', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "object": "billing_subscription",  
  "has_payment_method": true,  
  "soft_limit_usd": 100.0,  
  "hard_limit_usd": 100.0,  
  "system_hard_limit_usd": 100.0,  
  "access_until": 1640995200  
}
```

❗ 失败响应示例：

```
{  
  "error": {  
    "message": "获取配额失败",  
    "type": "upstream_error"  
  }  
}
```

🧾 字段说明：

- `object` （字符串）: 固定值"billing_subscription"
- `has_payment_method` （布尔型）: 是否有支付方式，固定为 true
- `soft_limit_usd` （数字）: 软限制额度（美元）
- `hard_limit_usd` （数字）: 硬限制额度（美元）
- `system_hard_limit_usd` （数字）: 系统硬限制额度（美元）
- `access_until` （数字）: 访问有效期时间戳，Token 过期时间

### 获取使用量信息

- **接口名称**：获取使用量信息
- **HTTP 方法**：GET
- **路径**：`/dashboard/billing/usage`
- **鉴权要求**：用户 Token
- **功能简介**：获取用户的配额使用量信息，兼容 OpenAI API 格式

💡 请求示例：

```
const response = await fetch('/dashboard/billing/usage', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "object": "list",  
  "total_usage": 2500.0  
}
```

❗ 失败响应示例：

```
{  
  "error": {  
    "message": "获取使用量失败",  
    "type": "new_api_error"  
  }  
}
```

🧾 字段说明：

- `object` （字符串）: 固定值"list" 
- `total_usage` （数字）: 总使用量，单位为 0.01 美元 

### 兼容 OpenAI SDK 路径 - 获取使用量信息

- **接口名称**：兼容 OpenAI SDK 路径 - 获取使用量信息
- **HTTP 方法**：GET
- **路径**：`/v1/dashboard/billing/usage`
- **鉴权要求**：用户 Token
- **功能简介**：与上述接口功能完全相同，提供 OpenAI SDK 兼容路径

💡 请求示例：

```
const response = await fetch('/v1/dashboard/billing/usage', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "object": "list",  
  "total_usage": 2500.0  
}
```

❗ 失败响应示例：

```
{  
  "error": {  
    "message": "获取使用量失败",  
    "type": "new_api_error"  
  }  
}
```

🧾 字段说明：

- `object` （字符串）: 固定值"list"
- `total_usage` （数字）: 总使用量，单位为 0.01 美元 

