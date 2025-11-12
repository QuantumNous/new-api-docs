# Redemption Code Management Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A dedicated redemption code system for administrators. Supports batch generation, status management, search filtering, and other functions. Includes maintenance features for automatically cleaning up invalid redemption codes. Primarily used for promotional activities and user incentives.

## 🔐 Administrator Authentication

### Get Redemption Code List

- **Interface Name**: Get Redemption Code List
- **HTTP Method**: GET
- **Path**: `/api/redemption/`
- **Authentication Requirement**: Administrator
- **Feature Description**: Paginated retrieval of the list information for all redemption codes in the system.

💡 Request Example:

```
const response = await fetch('/api/redemption/?p=1&page_size=20', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
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
        "name": "新年活动兑换码",  
        "key": "abc123def456",  
        "status": 1,  
        "quota": 100000,  
        "created_time": 1640908800,  
        "redeemed_time": 0,  
        "expired_time": 1640995200,  
        "used_user_id": 0  
      }  
    ],  
    "total": 50,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve redemption code list"  
}
```

🧾 Field Description:

- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20
- `items` (Array): List of redemption code information
- `total` (Number): Total number of redemption codes
- `page` (Number): Current page number
- `page_size` (Number): Items per page

### Search Redemption Codes

- **Interface Name**: Search Redemption Codes
- **HTTP Method**: GET
- **Path**: `/api/redemption/search`
- **Authentication Requirement**: Administrator
- **Feature Description**: Search redemption codes based on keywords, supports searching by ID and name.

💡 Request Example:

```
const response = await fetch('/api/redemption/search?keyword=新年&p=1&page_size=20', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
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
        "name": "新年活动兑换码",  
        "key": "abc123def456",  
        "status": 1,  
        "quota": 100000  
      }  
    ],  
    "total": 1,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to search redemption codes"  
}
```

🧾 Field Description:

- `keyword` (String): Search keyword, can match redemption code name or ID
- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20

### Get Single Redemption Code

- **Interface Name**: Get Single Redemption Code
- **HTTP Method**: GET
- **Path**: `/api/redemption/:id`
- **Authentication Requirement**: Administrator
- **Feature Description**: Retrieve detailed information for the specified redemption code.

💡 Request Example:

```
const response = await fetch('/api/redemption/123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
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
    "name": "新年活动兑换码",  
    "key": "abc123def456",  
    "status": 1,  
    "quota": 100000,  
    "created_time": 1640908800,  
    "redeemed_time": 0,  
    "expired_time": 1640995200,  
    "used_user_id": 0,  
    "user_id": 1  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Redemption code does not exist"  
}
```

🧾 Field Description:

`id` (Number): Redemption code ID, passed via URL path

### Create Redemption Code

- **Interface Name**: Create Redemption Code
- **HTTP Method**: POST
- **Path**: `/api/redemption/`
- **Authentication Requirement**: Administrator
- **Feature Description**: Batch creation of redemption codes, supports creating multiple at once.

💡 Request Example:

```
const response = await fetch('/api/redemption/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    name: "春节活动兑换码",  
    count: 10,  
    quota: 100000,  
    expired_time: 1640995200  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    "abc123def456",  
    "def456ghi789",  
    "ghi789jkl012"  
  ]  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Redemption code name length must be between 1 and 20"  
}
```

🧾 Field Description:

- `name` (String): Redemption code name, length must be between 1 and 20 characters
- `count` (Number): Number of redemption codes to create, must be greater than 0 and no more than 100
- `quota` (Number): Quota amount for each redemption code
- `expired_time` (Number): Expiration timestamp, 0 means never expires
- `data` (Array): List of successfully created redemption codes

### Update Redemption Code

- **Interface Name**: Update Redemption Code
- **HTTP Method**: PUT
- **Path**: `/api/redemption/`
- **Authentication Requirement**: Administrator
- **Feature Description**: Update redemption code information, supports updating status only or full update.

💡 Request Example (Full Update):

```
const response = await fetch('/api/redemption/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    id: 123,  
    name: "更新的兑换码名称",  
    quota: 200000,  
    expired_time: 1672531200  
  })  
});  
const data = await response.json();
```

💡 Request Example (Status Update Only):

```
const response = await fetch('/api/redemption/?status_only=true', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    id: 123,  
    status: 2  
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
    "name": "更新的兑换码名称",  
    "status": 1,  
    "quota": 200000,  
    "expired_time": 1672531200  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Expiration time cannot be earlier than the current time"  
}
```

🧾 Field Description:

- `id` (Number): Redemption code ID, required
- `status_only` (Query Parameter): Whether to update status only
- `name` (String): Redemption code name, optional
- `quota` (Number): Quota amount, optional
- `expired_time` (Number): Expiration timestamp, optional
- `status` (Number): Redemption code status, optional

### Delete Invalid Redemption Codes

- **Interface Name**: Delete Invalid Redemption Codes
- **HTTP Method**: DELETE
- **Path**: `/api/redemption/invalid`
- **Authentication Requirement**: Administrator
- **Feature Description**: Batch delete redemption codes that are used, disabled, or expired.

💡 Request Example:

```
const response = await fetch('/api/redemption/invalid', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
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
  "data": 15  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Deletion failed"  
}
```

🧾 Field Description:

- No request parameters
- `data` (Number): Number of redemption codes deleted

### Delete Redemption Code

- **Interface Name**: Delete Redemption Code
- **HTTP Method**: DELETE
- **Path**: `/api/redemption/:id`
- **Authentication Requirement**: Administrator
- **Feature Description**: Delete the specified redemption code.

💡 Request Example:

```
const response = await fetch('/api/redemption/123', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
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
  "message": "Redemption code does not exist"  
}
```

🧾 Field Description:

`id` (Number): Redemption code ID, passed via URL path