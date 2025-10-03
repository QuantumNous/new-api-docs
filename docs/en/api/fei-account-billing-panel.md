# Account Billing Dashboard Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    This is an OpenAI SDK compatible billing query interface. It uses Token authentication and provides subscription information and usage queries. It is primarily used for third-party applications and SDK integration, ensuring full compatibility with the OpenAI API.

## 🔐 User Authentication

### Get Subscription Quota Information

- **Interface Name**：Get Subscription Quota Information
- **HTTP Method**：GET
- **Path**：`/dashboard/billing/subscription`
- **Authentication Required**：User Token
- **Function Brief**：Retrieves the user's subscription quota information, including total quota, hard limit, and access validity period, compatible with the OpenAI API format.

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

❗ Failure Response Example:

```
{  
  "error": {  
    "message": "获取配额失败",  
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

### OpenAI SDK Compatible Path - Get Subscription Quota Information

- **Interface Name**：OpenAI SDK Compatible Path - Get Subscription Quota Information
- **HTTP Method**：GET
- **Path**：`/v1/dashboard/billing/subscription`
- **Authentication Required**：User Token
- **Function Brief**：Functionally identical to the interface above, providing an OpenAI SDK compatible path.

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

❗ Failure Response Example:

```
{  
  "error": {  
    "message": "获取配额失败",  
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

### Get Usage Information

- **Interface Name**：Get Usage Information
- **HTTP Method**：GET
- **Path**：`/dashboard/billing/usage`
- **Authentication Required**：User Token
- **Function Brief**：Retrieves the user's quota usage information, compatible with the OpenAI API format.

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

❗ Failure Response Example:

```
{  
  "error": {  
    "message": "获取使用量失败",  
    "type": "new_api_error"  
  }  
}
```

🧾 Field Description:

- `object` (String): Fixed value "list"
- `total_usage` (Number): Total usage, measured in $0.01 USD

### OpenAI SDK Compatible Path - Get Usage Information

- **Interface Name**：OpenAI SDK Compatible Path - Get Usage Information
- **HTTP Method**：GET
- **Path**：`/v1/dashboard/billing/usage`
- **Authentication Required**：User Token
- **Function Brief**：Functionally identical to the interface above, providing an OpenAI SDK compatible path.

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

❗ Failure Response Example:

```
{  
  "error": {  
    "message": "获取使用量失败",  
    "type": "new_api_error"  
  }  
}
```

🧾 Field Description:

- `object` (String): Fixed value "list"
- `total_usage` (Number): Total usage, measured in $0.01 USD