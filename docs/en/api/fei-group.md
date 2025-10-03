# Group Module

!!! info "Function Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A simple group name query interface. Primarily used for dropdown selection components in the administrator interface. Unlike the user-side group interface, it only returns a list of names without detailed information such as Ratios.

## 🔐 Administrator Authentication

### Get All Group List

- **Interface Name**: Get All Group List
- **HTTP Method**: GET
- **Path**: `/api/group/`
- **Authentication Requirement**: Administrator
- **Function Summary**: Retrieves the list of names for all user groups in the system, used for administrator configuration and frontend component selection

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

`data` (Array): List of group names, containing the names of all configured user groups in the system