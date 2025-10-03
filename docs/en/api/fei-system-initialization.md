## 核心概念 (Core Concepts)

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API access credentials or text units processed by models | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# System Initialization Module

!!! info "Feature Description"
    The functional interface prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    The System Initialization Module is responsible for first-time deployment configuration and runtime status monitoring. It supports SQLite, MySQL, and PostgreSQL databases, including Root user creation and system parameter initialization. The status interface provides real-time system information, including OAuth configuration, feature toggles, etc.

## 🔐 Public Endpoints (No Authentication Required)

### Get System Initialization Status

- **Endpoint Name**：Get System Initialization Status
- **HTTP Method**：GET
- **Path**：`/api/setup`
- **Authentication Required**：Public
- **Function Description**：Check if the system initialization is complete, retrieve database type and Root user status

💡 Request Example：

```
const response = await fetch('/api/setup', {  
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
  "data": {  
    "status": false,  
    "root_init": true,  
    "database_type": "sqlite"  
  }  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "系统错误"  
}
```

🧾 Field Description：

- `status` (Boolean): System initialization status
- `root_init` (Boolean): Whether the Root user exists
- `database_type` (String): Database type, optional values: "mysql", "postgres", "sqlite"

### Complete First-Time Installation Wizard

- **Endpoint Name**：Complete First-Time Installation Wizard
- **HTTP Method**：POST
- **Path**：`/api/setup`
- **Authentication Required**：Public
- **Function Description**：Create the Root administrator account and complete system initialization configuration

💡 Request Example：

```
const response = await fetch('/api/setup', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json'  
  },  
  body: JSON.stringify({  
    username: "admin",  
    password: "password123",  
    confirmPassword: "password123",  
    SelfUseModeEnabled: false,  
    DemoSiteEnabled: false  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "系统初始化完成"  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "用户名长度不能超过12个字符"  
}
```

🧾 Field Description：

- `username` (String): Administrator username, maximum length 12 characters
- `password` (String): Administrator password, minimum 8 characters
- `confirmPassword` (String): Confirm password, must match password
- `SelfUseModeEnabled` (Boolean): Whether to enable Self-Use Mode
- `DemoSiteEnabled` (Boolean): Whether to enable Demo Site Mode

### Get Runtime Status Summary

- **Endpoint Name**：Get Runtime Status Summary
- **HTTP Method**：GET
- **Path**：`/api/status`
- **Authentication Required**：Public
- **Function Description**：Retrieve system runtime status, configuration information, and feature toggle status

💡 Request Example：

```
const response = await fetch('/api/status', {  
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
  "data": {  
    "version": "v1.0.0",  
    "start_time": 1640995200,  
    "email_verification": false,  
    "github_oauth": true,  
    "github_client_id": "your_client_id",  
    "system_name": "New API",  
    "quota_per_unit": 500000,  
    "display_in_currency": true,  
    "enable_drawing": true,  
    "enable_task": true,  
    "setup": true  
  }  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "获取状态失败"  
}
```

🧾 Field Description：

- `version` (String): System version number
- `start_time` (Number): System startup timestamp
- `email_verification` (Boolean): Whether email verification is enabled
- `github_oauth` (Boolean): Whether GitHub OAuth login is enabled
- `github_client_id` (String): GitHub OAuth Client ID
- `system_name` (String): System name
- `quota_per_unit` (Number): Quota quantity per unit
- `display_in_currency` (Boolean): Whether to display in currency format
- `enable_drawing` (Boolean): Whether drawing functionality is enabled
- `enable_task` (Boolean): Whether task functionality is enabled
- `setup` (Boolean): Whether system initialization is complete

### Uptime-Kuma Compatible Status Probe

- **Endpoint Name**：Uptime-Kuma Compatible Status Probe
- **HTTP Method**：GET
- **Path**：`/api/uptime/status`
- **Authentication Required**：Public
- **Function Description**：Provides a status check interface compatible with the Uptime-Kuma monitoring system

💡 Request Example：

```
const response = await fetch('/api/uptime/status', {  
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
  "data": [  
    {  
      "categoryName": "OpenAI服务",  
      "monitors": [  
        {  
          "name": "GPT-4",  
          "group": "OpenAI",  
          "status": 1,  
          "uptime": 99.5  
        }  
      ]  
    }  
  ]  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "获取监控数据失败"  
}
```

🧾 Field Description：

- `categoryName` (String): Monitoring category name
- `monitors` (Array): List of monitoring items
    - `name` (String): Monitoring item name
    - `group` (String): Monitoring group name
    - `status` (Number): Status code, 1=Normal, 0=Abnormal
    - `uptime` (Number): Availability percentage

## 🔐 Administrator Authentication

### Test Backend and Dependent Components

- **Endpoint Name**：Test Backend and Dependent Components
- **HTTP Method**：GET
- **Path**：`/api/status/test`
- **Authentication Required**：Administrator
- **Function Description**：Test the connection status and health of various system components

💡 Request Example：

```
const response = await fetch('/api/status/test', {  
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
  "message": "所有组件测试通过",  
  "data": {  
    "database": "connected",  
    "redis": "connected",  
    "external_apis": "healthy"  
  }  
}
```

❗ Failure Response Example：

```
{  
  "success": false,  
  "message": "数据库连接失败"  
}
```

🧾 Field Description：

- `database` (String): Database connection status
- `redis` (String): Redis connection status
- `external_apis` (String): External API health status