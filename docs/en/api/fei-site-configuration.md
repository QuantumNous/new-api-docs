# Site Configuration Module

!!! info "Function Description"
    The unified API prefix is http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    This module manages system configurations with the highest privilege, accessible only by Root users. It includes features like global parameter configuration, model ratio reset, and console setting migration. Configuration updates involve strict dependency validation logic.

## 🔐 Root Authentication

### Get Global Configuration
- **Interface Name**：Get Global Configuration
- **HTTP Method**：GET
- **Path**：`/api/option/`
- **Authentication Requirement**：Root
- **Function Brief**：Retrieves all global configuration options for the system, filtering sensitive information such as Token, Secret, and Key.
💡 Request Example：

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

✅ Successful Response Example：

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

❗ Failed Response Example：

```
{  
  "success": false,  
  "message": "Failed to retrieve configuration"  
}
```

🧾 Field Description：

`data` (Array): List of configuration items option.go：15-18

- `key` (String): Configuration item key name
- `value` (String): Configuration item value; sensitive information has been filtered option.go：22-24


### Update Global Configuration

- **Interface Name**：Update Global Configuration
- **HTTP Method**：PUT
- **Path**：`/api/option/`
- **Authentication Requirement**：Root
- **Function Brief**：Updates a single global configuration item, including configuration validation and dependency checks.

💡 Request Example：

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

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "Configuration updated successfully"  
}
```

❗ Failed Response Example：

```
{  
  "success": false,  
  "message": "Cannot enable GitHub OAuth. Please fill in the GitHub Client Id and GitHub Client Secret first!"  
}
```

🧾 Field Description：

- `key` (String): Configuration item key name, required option.go：39-42
- `value` (Any Type): Configuration item value, supports boolean, numeric, string, and other types option.go：54-63

### Reset Model Ratio

- **Interface Name**：Reset Model Ratio
- **HTTP Method**：POST
- **Path**：`/api/option/rest_model_ratio`
- **Authentication Requirement**：Root
- **Function Brief**：Resets the ratio configuration of all models to their default values, used for bulk resetting model pricing.

💡 Request Example：

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

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "Model ratio reset successful"  
}
```

❗ Failed Response Example：

```
{  
  "success": false,  
  "message": "Failed to reset model ratio"  
}
```

🧾 Field Description：

No request parameters. Upon execution, all model ratio configurations will be reset.

### Migrate Old Console Configuration

- **Interface Name**：Migrate Old Console Configuration
- **HTTP Method**：POST
- **Path**：`/api/option/migrate_console_setting`
- **Authentication Requirement**：Root
- **Function Brief**：Migrates old version console configurations to the new configuration format, including API information, announcements, FAQ, etc.

💡 Request Example：

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

✅ Successful Response Example：

```
{  
  "success": true,  
  "message": "migrated"  
}
```

❗ Failed Response Example：

```
{  
  "success": false,  
  "message": "Migration failed"  
}
```

🧾 Field Description：

- No request parameters
- Migration content includes:

    - `ApiInfo` → `console_setting.api_info` 
    - `Announcements` → `console_setting.announcements` 
    - `FAQ` → `console_setting.faq` 
    - `UptimeKumaUrl/UptimeKumaSlug` → `console_setting.uptime_kuma_groups`