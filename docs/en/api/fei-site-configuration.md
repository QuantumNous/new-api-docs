# Site Configuration Module

!!! info "Function Description"
    The unified API prefix is http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    This is the highest-level system configuration management, accessible only to Root users. It includes features like global parameter configuration, model ratio reset, and console setting migration. Configuration updates involve strict dependency validation logic.

## 🔐 Root Authentication

### Retrieve Global Configuration
- **Interface Name**: Retrieve Global Configuration
- **HTTP Method**: GET
- **Path**: `/api/option/`
- **Authentication Requirement**: Root
- **Function Summary**: Retrieves all global configuration options for the system, filtering sensitive information such as Tokens, Secrets, and Keys.
💡 Request Example:

```
const response = await fetch('/api/option/', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'your_user_id'
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

`data` (Array): List of configuration items option.go: 15-18

- `key` (String): Configuration item key name
- `value` (String): Configuration item value; sensitive information has been filtered option.go: 22-24


### Update Global Configuration

- **Interface Name**: Update Global Configuration
- **HTTP Method**: PUT
- **Path**: `/api/option/`
- **Authentication Requirement**: Root
- **Function Summary**: Updates a single global configuration item, including configuration validation and dependency checks.

💡 Request Example:

```
const response = await fetch('/api/option/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'your_user_id'
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
  "message": "Cannot enable GitHub OAuth. Please fill in the GitHub Client Id and GitHub Client Secret first!"  
}
```

🧾 Field Description:

- `key` (String): Configuration item key name, required option.go: 39-42
- `value` (Any Type): Configuration item value, supporting boolean, number, string, and other types option.go: 54-63

### Reset Model Ratios

- **Interface Name**: Reset Model Ratios
- **HTTP Method**: POST
- **Path**: `/api/option/rest_model_ratio`
- **Authentication Requirement**: Root
- **Function Summary**: Resets the ratio configuration for all models to their default values, used for bulk resetting model pricing.

💡 Request Example:

```
const response = await fetch('/api/option/rest_model_ratio', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "Model ratios reset successfully"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to reset model ratios"  
}
```

🧾 Field Description:

No request parameters. Execution will reset all model ratio configurations.

### Migrate Legacy Console Settings

- **Interface Name**: Migrate Legacy Console Settings
- **HTTP Method**: POST
- **Path**: `/api/option/migrate_console_setting`
- **Authentication Requirement**: Root
- **Function Summary**: Migrates old version console settings to the new configuration format, including API information, announcements, FAQ, etc.

💡 Request Example:

```
const response = await fetch('/api/option/migrate_console_setting', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'your_user_id'
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