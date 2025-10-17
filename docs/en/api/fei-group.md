# Group Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A simple group name query interface. Primarily used for dropdown selection components in the administrator interface. Unlike the user-facing group interface, this only returns a list of names and does not include detailed information such as ratios.

## 🔐 Administrator Authentication

### Get All Groups List

- **Interface Name**: Get All Groups List
- **HTTP Method**: GET
- **Path**: `/api/group/`
- **Authentication Required**: Administrator
- **Function Description**: Retrieves a list of names for all user groups in the system, used for administrator configuration and frontend component selection.

💡 Request Example:

```
const response = await fetch('/api/group/', {  
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
  "message": "Failed to retrieve group list"  
}
```

🧾 Field Description:

`data` (Array): A list of group names, containing the names of all configured user groups in the system.