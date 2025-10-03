## 核心概念 (Core Concepts)

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API访问凭证，也指模型处理的文本单元 | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# Data Statistics Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    An aggregated statistics system for usage data. Administrators can view site-wide statistics, and users can view personal statistics. Data is grouped by model and date, used to generate charts and reports, and monitor system usage trends.

## 🔐 User Authentication

### My Usage Statistics by Date

- **Interface Name**：My Usage Statistics by Date
- **HTTP Method**：GET
- **Path**：`/api/data/self`
- **Authentication Requirement**：User
- **Feature Summary**：Get the current user's usage data statistics by date, supporting time range queries

💡 Request Example：

```
const response = await fetch('/api/data/self?start_timestamp=1640908800&end_timestamp=1640995200', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    {  
      "model_name": "gpt-3.5-turbo",  
      "count": 25,  
      "quota": 12500,  
      "token_used": 2000,  
      "created_at": 1640995200,  
      "user_id": 1,  
      "username": "testuser"  
    },  
    {  
      "model_name": "gpt-4",  
      "count": 10,  
      "quota": 30000,  
      "token_used": 1500,  
      "created_at": 1640995200,  
      "user_id": 1,  
      "username": "testuser"  
    }  
  ]  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "获取个人统计数据失败"  
}
```

🧾 Field Description：

- `start_timestamp` (Number): Start timestamp, optional
- `end_timestamp` (Number): End timestamp, optional
- `data` (Array): List of personal statistics data 

    - `model_name` (String): Model name
    - `count` (Number): Request count
    - `quota` (Number): Quota consumption
    - `token_used` (Number): Token usage
    - `created_at` (Number): Statistics date timestamp
    - `user_id` (Number): User ID
    - `username` (String): Username

## 🔐 Administrator Authentication

### Site-wide Usage Statistics by Date

- **Interface Name**：Site-wide Usage Statistics by Date
- **HTTP Method**：GET
- **Path**：`/api/data/`
- **Authentication Requirement**：Administrator
- **Feature Summary**：Get the system's site-wide usage data statistics by date, supporting filtering by username and time range queries

💡 Request Example：

```
const response = await fetch('/api/data/?start_timestamp=1640908800&end_timestamp=1640995200&username=testuser', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    {  
      "model_name": "gpt-3.5-turbo",  
      "count": 150,  
      "quota": 75000,  
      "token_used": 12500,  
      "created_at": 1640995200  
    },  
    {  
      "model_name": "gpt-4",  
      "count": 50,  
      "quota": 150000,  
      "token_used": 8000,  
      "created_at": 1640995200  
    }  
  ]  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "获取统计数据失败"  
}
```

🧾 Field Description：

- `start_timestamp` (Number): Start timestamp, optional
- `end_timestamp` (Number): End timestamp, optional
- `username` (String): Username filter, optional 
- `data` (Array): List of statistics data, aggregated by model and date 

    - `model_name` (String): Model name
    - `count` (Number): Total request count
    - `quota` (Number): Total quota consumption
    - `token_used` (Number): Total token usage
    - `created_at` (Number): Statistics date timestamp