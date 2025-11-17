# Group Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication Tokens. HTTP is only recommended for development environments.

    A simple interface for querying group names. Primarily used for dropdown selection components in the administrator interface. Unlike the user-side group interface, it only returns a list of names and does not include detailed information such as Ratios.

## 🔐 Administrator Authentication

### Get All Group List

- **Interface Name**: Get All Group List
- **HTTP Method**: GET
- **Path**: `/api/group/`
- **Authentication Required**: Administrator
- **Function Description**: Retrieves a list of names for all user Groups in the system, used for administrator configuration and frontend component selection.

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

`data` (Array): A list of group names, containing the names of all configured user Groups in the system.