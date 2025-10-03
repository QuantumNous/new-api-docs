# Redemption Code Management Module

!!! info "Feature Description"
    The interface prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    This is an administrator-exclusive redemption code system. It supports batch generation, status management, search filtering, and includes maintenance features for automatically cleaning up invalid redemption codes. It is primarily used for promotional activities and user incentives.

## 🔐 Administrator Authentication

### Get Redemption Code List

- **Interface Name**: Get Redemption Code List
- **HTTP Method**: GET
- **Path**: `/api/redemption/`
- **Authentication Requirement**: Administrator
- **Function Summary**: Paginated retrieval of the list of all redemption codes in the system

💡 Request Example:

```
const response = await fetch('/api/redemption/?p=1&page_size=20', {  
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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "获取兑换码列表失败"  
}
```

🧾 Field Descriptions:

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
- **Function Summary**: Search redemption codes based on keywords, supports searching by ID and Name

💡 Request Example:

```
const response = await fetch('/api/redemption/search?keyword=新年&p=1&page_size=20', {  
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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "搜索兑换码失败"  
}
```

🧾 Field Descriptions:

- `keyword` (String): Search keyword, can match redemption code name or ID
- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20

### Get Single Redemption Code

- **Interface Name**: Get Single Redemption Code
- **HTTP Method**: GET
- **Path**: `/api/redemption/:id`
- **Authentication Requirement**: Administrator
- **Function Summary**: Retrieve detailed information for a specified redemption code

💡 Request Example:

```
const response = await fetch('/api/redemption/123', {  
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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "兑换码不存在"  
}
```

🧾 Field Descriptions:

`id` (Number): Redemption code ID, passed via URL path

### Create Redemption Codes

- **Interface Name**: Create Redemption Codes
- **HTTP Method**: POST
- **Path**: `/api/redemption/`
- **Authentication Requirement**: Administrator
- **Function Summary**: Batch creation of redemption codes, supports creating multiple codes at once

💡 Request Example:

```
const response = await fetch('/api/redemption/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "兑换码名称长度必须在1-20之间"  
}
```

🧾 Field Descriptions:

- `name` (String): Redemption code name, length must be between 1 and 20 characters
- `count` (Number): Number of redemption codes to create, must be greater than 0 and not exceed 100
- `quota` (Number): Quota amount for each redemption code
- `expired_time` (Number): Expiration timestamp, 0 means never expires
- `data` (Array): List of successfully created redemption codes

### Update Redemption Codes

- **Interface Name**: Update Redemption Codes
- **HTTP Method**: PUT
- **Path**: `/api/redemption/`
- **Authentication Requirement**: Administrator
- **Function Summary**: Update redemption code information, supports updating status only or a complete update

💡 Request Example (Complete Update):

```
const response = await fetch('/api/redemption/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

💡 Request Example (Status Only Update):

```
const response = await fetch('/api/redemption/?status_only=true', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "过期时间不能早于当前时间"  
}
```

🧾 Field Descriptions:

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
- **Function Summary**: Batch delete used, disabled, or expired redemption codes

💡 Request Example:

```
const response = await fetch('/api/redemption/invalid', {  
  method: 'DELETE',  
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
  "data": 15  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "删除失败"  
}
```

🧾 Field Descriptions:

- No request parameters
- `data` (Number): Number of redemption codes deleted

### Delete Redemption Code

- **Interface Name**: Delete Redemption Code
- **HTTP Method**: DELETE
- **Path**: `/api/redemption/:id`
- **Authentication Requirement**: Administrator
- **Function Summary**: Delete the specified redemption code

💡 Request Example:

```
const response = await fetch('/api/redemption/123', {  
  method: 'DELETE',  
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
  "message": ""  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "兑换码不存在"  
}
```

🧾 Field Descriptions:

`id` (Number): Redemption code ID, passed via URL path