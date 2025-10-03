## 核心概念 (Core Concepts)

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API access credentials or text units processed by models | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# Site Configuration Module

!!! info "Feature Description"
    The API prefix is uniformly `http(s)://<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    This module provides system configuration management with the highest privileges, accessible only by Root users. It includes features like global parameter configuration, model ratio reset, and console setting migration. Configuration updates involve strict dependency validation logic.

## 🔐 Root Authentication

### Get Global Configuration
- **Interface Name**: Get Global Configuration
- **HTTP Method**: GET
- **Path**: `/api/option/`
- **Authentication Requirement**: Root
- **Function Description**: Retrieves all system global configuration options, filtering sensitive information such as Token, Secret, Key, etc.
💡 Request Example:

```
const response = await fetch('/api/option/', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
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
    {  
      "key": "SystemName",  
      "value": "New API"  
    },  
    {  
      "key": "DisplayInCurrencyEnabled",  
      "value": "true"  
    },  
    {  
      "key": "QuotaPerUnit",  
      "value": "500000"  
    }  
  ]  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve configuration"  
}
```

🧾 Field Description:

`data` (Array): Configuration item list option.go: 15-18

- `key` (String): Configuration item key name
- `value` (String): Configuration item value, sensitive information filtered option.go: 22-24


### Update Global Configuration

- **Interface Name**: Update Global Configuration
- **HTTP Method**: PUT
- **Path**: `/api/option/`
- **Authentication Requirement**: Root
- **Function Description**: Updates a single global configuration item, including configuration validation and dependency checks

💡 Request Example:

```
const response = await fetch('/api/option/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
  },  
  body: JSON.stringify({  
    key: "SystemName",  
    value: "My New API System"  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "Configuration updated successfully"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Cannot enable GitHub OAuth, please fill in the GitHub Client Id and GitHub Client Secret first!"  
}
```

🧾 Field Description:

- `key` (String): Configuration item key name, required option.go: 39-42
- `value` (Any Type): Configuration item value, supports boolean, number, string, etc. option.go: 54-63

### Reset Model Ratio

- **Interface Name**: Reset Model Ratio
- **HTTP Method**: POST
- **Path**: `/api/option/rest_model_ratio`
- **Authentication Requirement**: Root
- **Function Description**: Resets the ratio configuration of all models to their default values, used for bulk resetting model pricing

💡 Request Example:

```
const response = await fetch('/api/option/rest_model_ratio', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "Model ratio reset successfully"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to reset model ratio"  
}
```

🧾 Field Description:

No request parameters, all model ratio configurations will be reset after execution

### Migrate Legacy Console Configuration

- **Interface Name**: Migrate Legacy Console Configuration
- **HTTP Method**: POST
- **Path**: `/api/option/migrate_console_setting`
- **Authentication Requirement**: Root
- **Function Description**: Migrates old version console configurations to the new configuration format, including API information, announcements, FAQ, etc.

💡 Request Example:

```
const response = await fetch('/api/option/migrate_console_setting', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "migrated"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Migration failed"  
}
```

🧾 Field Description:

- No request parameters
- Migration content includes:

    - `ApiInfo` → `console_setting.api_info` 
    - `Announcements` → `console_setting.announcements` 
    - `FAQ` → `console_setting.faq` 
    - `UptimeKumaUrl/UptimeKumaSlug` → `console_setting.uptime_kuma_groups`