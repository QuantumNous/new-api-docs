# System Initialization Module

!!! info "Feature Description"
    The unified prefix for feature interfaces is http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    The System Initialization Module is responsible for initial deployment configuration and operational status monitoring. It supports SQLite, MySQL, and PostgreSQL databases, including Root user creation and system parameter initialization. The status interface provides real-time system information, including OAuth configuration, feature toggles, and more.

## 🔐 No Authentication Required

### Get System Initialization Status

- **Interface Name**: Get System Initialization Status
- **HTTP Method**: GET
- **Path**: `/api/setup`
- **Authentication Requirement**: Public
- **Function Description**: Checks if the system initialization is complete, retrieves the database type and Root user status.

💡 Request Example:

```
const response = await fetch('/api/setup', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "系统错误"  
}
```

🧾 Field Description:

- `status` (Boolean): Whether the system initialization is complete
- `root_init` (Boolean): Whether the Root user exists
- `database_type` (String): Database type, optional values: "mysql", "postgres", "sqlite"

### Complete First-Time Installation Wizard

- **Interface Name**: Complete First-Time Installation Wizard
- **HTTP Method**: POST
- **Path**: `/api/setup`
- **Authentication Requirement**: Public
- **Function Description**: Creates the Root administrator account and completes the system initialization configuration.

💡 Request Example:

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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "System initialization complete"  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Username length cannot exceed 12 characters"  
}
```

🧾 Field Description:

- `username` (String): Administrator username, maximum length 12 characters
- `password` (String): Administrator password, minimum 8 characters
- `confirmPassword` (String): Confirmation password, must match password
- `SelfUseModeEnabled` (Boolean): Whether to enable Self-Use Mode
- `DemoSiteEnabled` (Boolean): Whether to enable Demo Site Mode

### Get Operational Status Summary

- **Interface Name**: Get Operational Status Summary
- **HTTP Method**: GET
- **Path**: `/api/status`
- **Authentication Requirement**: Public
- **Function Description**: Retrieves system operational status, configuration information, and feature toggle states.

💡 Request Example:

```
const response = await fetch('/api/status', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve status"  
}
```

🧾 Field Description:

- `version` (String): System version number
- `start_time` (Number): System start timestamp
- `email_verification` (Boolean): Whether email verification is enabled
- `github_oauth` (Boolean): Whether GitHub OAuth login is enabled
- `github_client_id` (String): GitHub OAuth Client ID
- `system_name` (String): System name
- `quota_per_unit` (Number): Quota amount per unit
- `display_in_currency` (Boolean): Whether to display in currency format
- `enable_drawing` (Boolean): Whether drawing functionality is enabled
- `enable_task` (Boolean): Whether task functionality is enabled
- `setup` (Boolean): Whether system initialization is complete

### Uptime-Kuma Compatible Status Probe

- **Interface Name**: Uptime-Kuma Compatible Status Probe
- **HTTP Method**: GET
- **Path**: `/api/uptime/status`
- **Authentication Requirement**: Public
- **Function Description**: Provides a status check interface compatible with the Uptime-Kuma monitoring system.

💡 Request Example:

```
const response = await fetch('/api/uptime/status', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "data": [  
    {  
      "categoryName": "OpenAI Service",  
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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve monitoring data"  
}
```

🧾 Field Description:

- `categoryName` (String): Monitor category name
- `monitors` (Array): List of monitoring items
    - `name` (String): Monitor item name
    - `group` (String): Monitor group name
    - `status` (Number): Status code, 1=Normal, 0=Abnormal
    - `uptime` (Number): Availability percentage

## 🔐 Administrator Authentication

### Test Backend and Dependent Components

- **Interface Name**: Test Backend and Dependent Components
- **HTTP Method**: GET
- **Path**: `/api/status/test`
- **Authentication Requirement**: Administrator
- **Function Description**: Tests the connection status and health of various system components.

💡 Request Example:

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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "All components tested successfully",  
  "data": {  
    "database": "connected",  
    "redis": "connected",  
    "external_apis": "healthy"  
  }  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Database connection failed"  
}
```

🧾 Field Description:

- `database` (String): Database connection status
- `redis` (String): Redis connection status
- `external_apis` (String): External API health status