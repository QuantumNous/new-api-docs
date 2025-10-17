# Token Management Module

!!! info "Function Description"
    The interface prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to ensure authentication tokens. HTTP is only recommended for development environments.

    A complete management system for user API Tokens. Supports features such as Token creation, updating, deletion, and batch operations. Includes fine-grained controls like model restrictions, IP restrictions, quota management, and expiration time. This is the core data source for the frontend Token page.

## 🔐 User Authentication

### Get All Tokens

- **Interface Name**: Get All Tokens
- **HTTP Method**: GET
- **Path**: `/api/token/`
- **Authentication Requirement**: User
- **Function Description**: Paginates and retrieves the list of all Tokens belonging to the current user.

💡 Request Example:

```
const response = await fetch('/api/token/?p=1&size=20', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
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
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "name": "API Token",  
        "key": "<YOUR_API_KEY>",  
        "status": 1,  
        "remain_quota": 1000000,  
        "unlimited_quota": false,  
        "expired_time": 1640995200,  
        "created_time": 1640908800,  
        "accessed_time": 1640995000  
      }  
    ],  
    "total": 5,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve Token list"  
}
```

🧾 Field Description:

- `p` (Number): Page number, defaults to 1
- `size` (Number): Items per page, defaults to 20
- `items` (Array): List of Token information
- `total` (Number): Total number of Tokens
- `page` (Number): Current page number
- `page_size` (Number): Items per page

### Search Tokens

- **Interface Name**: Search Tokens
- **HTTP Method**: GET
- **Path**: `/api/token/search`
- **Authentication Requirement**: User
- **Function Description**: Searches the user's Tokens based on keywords and Token values.

💡 Request Example:

```
const response = await fetch('/api/token/search?keyword=api&token=sk-123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
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
      "id": 1,  
      "name": "API Token",  
      "key": "sk-your-token-placeholder",  
      "status": 1,  
      "remain_quota": 1000000  
    }  
  ]  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to search Tokens"  
}
```

🧾 Field Description:

- `keyword` (String): Search keyword, matches Token name
- `token` (String): Token value search, supports partial matching

### Get Single Token

- **Interface Name**: Get Single Token
- **HTTP Method**: GET
- **Path**: `/api/token/:id`
- **Authentication Requirement**: User
- **Function Description**: Retrieves detailed information for the specified Token.

💡 Request Example:

```
const response = await fetch('/api/token/123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
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
  "data": {  
    "id": 123,  
    "name": "API Token",  
    "key": "sk-your-token-placeholder",  
    "status": 1,  
    "remain_quota": 1000000,  
    "unlimited_quota": false,  
    "model_limits_enabled": true,  
    "model_limits": "gpt-3.5-turbo,gpt-4",  
    "allow_ips": "192.168.1.1,10.0.0.1",  
    "group": "default",  
    "expired_time": 1640995200,  
    "created_time": 1640908800,  
    "accessed_time": 1640995000  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Token does not exist"  
}
```

🧾 Field Description:

`id` (Number): Token ID, passed via URL path

### Create Token

- **Interface Name**: Create Token
- **HTTP Method**: POST
- **Path**: `/api/token/`
- **Authentication Requirement**: User
- **Function Description**: Creates a new API Token, supports batch creation.

💡 Request Example:

```
const response = await fetch('/api/token/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    name: "My API Token",  
    expired_time: 1640995200,  
    remain_quota: 1000000,  
    unlimited_quota: false,  
    model_limits_enabled: true,  
    model_limits: ["gpt-3.5-turbo", "gpt-4"],  
    allow_ips: "192.168.1.1,10.0.0.1",  
    group: "default"  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Token name is too long"  
}
```

🧾 Field Description:

- `name` (String): Token name, maximum length 30 characters
- `expired_time` (Number): Expiration timestamp, -1 means never expires
- `remain_quota` (Number): Remaining quota
- `unlimited_quota` (Boolean): Whether the quota is unlimited
- `model_limits_enabled` (Boolean): Whether model restrictions are enabled
- `model_limits` (Array): List of allowed models
- `allow_ips` (String): Allowed IP addresses, comma-separated
- `group` (String): Associated group

### Update Token

- **Interface Name**: Update Token
- **HTTP Method**: PUT
- **Path**: `/api/token/`
- **Authentication Requirement**: User
- **Function Description**: Updates Token configuration, supports status toggling and full updates.

💡 Request Example (Full Update):

```
const response = await fetch('/api/token/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id' 
  },  
  body: JSON.stringify({  
    id: 123,  
    name: "Updated Token",  
    expired_time: 1640995200,  
    remain_quota: 2000000,  
    unlimited_quota: false,  
    model_limits_enabled: true,  
    model_limits: ["gpt-3.5-turbo", "gpt-4"],  
    allow_ips: "192.168.1.1",  
    group: "vip"  
  })  
});  
const data = await response.json();
```

💡 Request Example (Status Update Only):

```
const response = await fetch('/api/token/?status_only=true', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    id: 123,  
    status: 1  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "id": 123,  
    "name": "Updated Token",  
    "status": 1  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Token has expired and cannot be enabled. Please modify the token expiration time first, or set it to never expire"  
}
```

🧾 Field Description:

- `id` (Number): Token ID, required
- `status_only` (Query Parameter): Whether to update status only
- Other fields are the same as the Create Token interface and are all optional

### Delete Token

- **Interface Name**: Delete Token
- **HTTP Method**: DELETE
- **Path**: `/api/token/:id`
- **Authentication Requirement**: User
- **Function Description**: Deletes the specified Token.

💡 Request Example:

```
const response = await fetch('/api/token/123', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id' 
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Token does not exist"  
}
```

🧾 Field Description:

`id` (Number): Token ID, passed via URL path

### Batch Delete Tokens

- **Interface Name**: Batch Delete Tokens
- **HTTP Method**: POST
- **Path**: `/api/token/batch`
- **Authentication Requirement**: User
- **Function Description**: Deletes multiple Tokens in a batch.

💡 Request Example:

```
const response = await fetch('/api/token/batch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    ids: [1, 2, 3, 4, 5]  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": 5  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Parameter error"  
}
```

🧾 Field Description:

- `ids` (Array): List of Token IDs to be deleted, required and cannot be empty
- `data` (Number): Number of Tokens successfully deleted