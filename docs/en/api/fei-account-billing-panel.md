## Core Concepts (核心概念)

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API访问凭证，也指模型处理的文本单元 | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# Account Billing Dashboard Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    OpenAI SDK compatible billing query interface. Uses Token authentication to provide subscription information and usage queries. Primarily intended for third-party applications and SDK integration, ensuring full compatibility with the OpenAI API.

## 🔐 User Authentication

### Retrieve Subscription Quota Information

- **Interface Name**: Retrieve Subscription Quota Information
- **HTTP Method**: GET
- **Path**: `/dashboard/billing/subscription`
- **Authentication Requirement**: User Token
- **Description**: Retrieves the user's subscription quota information, including total quota, hard limit, and access validity period, compatible with the OpenAI API format.

💡 Request Example:

```
const response = await fetch('/dashboard/billing/subscription', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "error": {  
    "message": "Failed to retrieve quota",  
    "type": "upstream_error"  
  }  
}
```

🧾 Field Description:

- `object` (String): Fixed value "billing_subscription"
- `has_payment_method` (Boolean): Whether a payment method exists, fixed as true
- `soft_limit_usd` (Number): Soft limit quota (USD)
- `hard_limit_usd` (Number): Hard limit quota (USD)
- `system_hard_limit_usd` (Number): System hard limit quota (USD)
- `access_until` (Number): Access validity timestamp, Token expiration time

### OpenAI SDK Compatible Path - Retrieve Subscription Quota Information

- **Interface Name**: OpenAI SDK Compatible Path - Retrieve Subscription Quota Information
- **HTTP Method**: GET
- **Path**: `/v1/dashboard/billing/subscription`
- **Authentication Requirement**: User Token
- **Description**: Functionally identical to the interface above, providing an OpenAI SDK compatible path.

💡 Request Example:

```
const response = await fetch('/v1/dashboard/billing/subscription', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "error": {  
    "message": "Failed to retrieve quota",  
    "type": "upstream_error"  
  }  
}
```

🧾 Field Description:

- `object` (String): Fixed value "billing_subscription"
- `has_payment_method` (Boolean): Whether a payment method exists, fixed as true
- `soft_limit_usd` (Number): Soft limit quota (USD)
- `hard_limit_usd` (Number): Hard limit quota (USD)
- `system_hard_limit_usd` (Number): System hard limit quota (USD)
- `access_until` (Number): Access validity timestamp, Token expiration time

### Retrieve Usage Information

- **Interface Name**: Retrieve Usage Information
- **HTTP Method**: GET
- **Path**: `/dashboard/billing/usage`
- **Authentication Requirement**: User Token
- **Description**: Retrieves the user's quota usage information, compatible with the OpenAI API format.

💡 Request Example:

```
const response = await fetch('/dashboard/billing/usage', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "object": "list",  
  "total_usage": 2500.0  
}
```

❗ Failed Response Example:

```
{  
  "error": {  
    "message": "Failed to retrieve usage",  
    "type": "new_api_error"  
  }  
}
```

🧾 Field Description:

- `object` (String): Fixed value "list"
- `total_usage` (Number): Total usage, unit is $0.01 USD

### OpenAI SDK Compatible Path - Retrieve Usage Information

- **Interface Name**: OpenAI SDK Compatible Path - Retrieve Usage Information
- **HTTP Method**: GET
- **Path**: `/v1/dashboard/billing/usage`
- **Authentication Requirement**: User Token
- **Description**: Functionally identical to the interface above, providing an OpenAI SDK compatible path.

💡 Request Example:

```
const response = await fetch('/v1/dashboard/billing/usage', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "object": "list",  
  "total_usage": 2500.0  
}
```

❗ Failed Response Example:

```
{  
  "error": {  
    "message": "Failed to retrieve usage",  
    "type": "new_api_error"  
  }  
}
```

🧾 Field Description:

- `object` (String): Fixed value "list"
- `total_usage` (Number): Total usage, unit is $0.01 USD