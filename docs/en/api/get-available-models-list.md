# Get Available Model List (Model)

!!! info "Description"
    The interface prefix is uniformly http(s)://`<your-domain>`

    Production environments should use HTTPS to secure authentication tokens. HTTP is only recommended for development environments.

- **Interface Name**: Get the list of models available to the frontend
- **HTTP Method**: GET
- **Path**: `/api/models`
- **Authentication Requirement**: User
- **Function Summary**: Retrieves the list of AI models accessible to the current user, used for frontend Dashboard display

 💡 Request Example:

```
const response = await fetch('/api/models', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

 ✅ Successful Response Example:

```
{  
  "success": true,  
  "data": {  
    "1": ["gpt-3.5-turbo", "gpt-4"],  
    "2": ["claude-3-sonnet", "claude-3-haiku"]  
  }  
}
```

 ❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "未授权访问"  
}
```

 🧾 Field Description:

- `data` (Object): Mapping from Channel ID to model list
    - Key (String): Channel ID
    - Value (Array): List of model names supported by this channel