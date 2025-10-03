## Core Concepts

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API access credentials, or text units processed by models | API access credentials, or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# Grouping Module

!!! info "Function Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A simple grouping name query interface. Primarily used for dropdown selection components in the administrator interface. Unlike the user-facing grouping interface, it only returns a list of names without detailed information such as ratios.

## 🔐 Administrator Authorization

### Retrieve All Group List

- **Interface Name**: Retrieve All Group List
- **HTTP Method**: GET
- **Path**: `/api/group/`
- **Authorization Requirement**: Administrator
- **Function Summary**: Retrieves a list of names for all user groups in the system, used for administrator configuration and frontend component selection.

💡 Request Example:

```
const response = await fetch('/api/group/', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    "default",  
    "vip",  
    "premium",  
    "enterprise"  
  ]  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取分组列表失败"  
}
```

🧾 Field Description:

`data` (Array): Group name list, containing the names of all configured user groups in the system.