# Log Module

!!! info "Feature Description"
    The unified API prefix is http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A layered log query system supporting administrators viewing site-wide logs and users viewing personal logs. It provides real-time statistics (RPM/TPM), multi-dimensional filtering, historical data cleanup, and other features. A CORS-enabled Token query interface facilitates third-party integration.

## 🔐 No Authentication Required

### Query Logs by Token

- **Interface Name**: Query Logs by Token
- **HTTP Method**: GET
- **Path**: `/api/log/token`
- **Authentication Requirement**: Public
- **Function Description**: Query related log records using the Token key, supporting cross-origin access.

💡 Request Example:

```
const response = await fetch('/api/log/token?key=<TOKEN_PLACEHOLDER>', {  
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
  "data": [  
    {  
      "id": 1,  
      "type": 2,  
      "content": "API调用成功",  
      "model_name": "gpt-4",  
      "quota": 1000,  
      "created_at": 1640995000  
    }  
  ]  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Token does not exist or unauthorized"  
}
```

🧾 Field Description:

`key` (String): Token key, required

## 🔐 User Authentication

### My Log Statistics

- **Interface Name**: My Log Statistics
- **HTTP Method**: GET
- **Path**: `/api/log/self/stat`
- **Authentication Requirement**: User
- **Function Description**: Retrieve the current user's log statistics, including quota consumption, request frequency, and Token usage.

💡 Request Example:

```
const response = await fetch('/api/log/self/stat?type=2&start_timestamp=1640908800&end_timestamp=1640995200&token_name=api_token&model_name=gpt-4&group=default', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
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
    "quota": 50000,  
    "rpm": 10,  
    "tpm": 1500  
  }  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve statistics"  
}
```

🧾 Field Description:

- `type` (Number): Log type. Optional values: 1=Recharge, 2=Consumption, 3=Management, 4=Error, 5=System
- `start_timestamp` (Number): Start timestamp
- `end_timestamp` (Number): End timestamp
- `token_name` (String): Filter by Token name
- `model_name` (String): Filter by Model name
- `group` (String): Filter by Group
- `quota` (Number): Total quota consumption within the specified time range
- `rpm` (Number): Requests Per Minute (last 60 seconds)
- `tpm` (Number): Tokens Per Minute (last 60 seconds)

### Retrieve My Logs

- **Interface Name**: Retrieve My Logs
- **HTTP Method**: GET
- **Path**: `/api/log/self`
- **Authentication Requirement**: User
- **Function Description**: Paginate and retrieve the current user's log records, supporting various filtering conditions.

💡 Request Example:

```
const response = await fetch('/api/log/self?p=1&page_size=20&type=2&start_timestamp=1640908800&end_timestamp=1640995200&token_name=api_token&model_name=gpt-4&group=default', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
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
        "user_id": 1,  
        "created_at": 1640995000,  
        "type": 2,  
        "content": "API调用成功",  
        "token_name": "api_token",  
        "model_name": "gpt-4",  
        "quota": 1000,  
        "prompt_tokens": 50,  
        "completion_tokens": 100  
      }  
    ],  
    "total": 25,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve logs"  
}
```

🧾 Field Description:

Request parameters are the same as the Get All Logs interface, but only return the current user's log records.

### Search My Logs

- **Interface Name**: Search My Logs
- **HTTP Method**: GET
- **Path**: `/api/log/self/search`
- **Authentication Requirement**: User
- **Function Description**: Search the current user's log records based on keywords.

💡 Request Example:

```
const response = await fetch('/api/log/self/search?keyword=gpt-4', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
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
      "type": 2,  
      "content": "GPT-4调用成功",  
      "model_name": "gpt-4",  
      "created_at": 1640995000  
    }  
  ]  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to search logs"  
}
```

🧾 Field Description:

`keyword` (String): Search keyword, matching the current user's log type.

## 🔐 Administrator Authentication

### Get All Logs

- **Interface Name**: Get All Logs
- **HTTP Method**: GET
- **Path**: `/api/log/`
- **Authentication Requirement**: Administrator
- **Function Description**: Paginate and retrieve all log records in the system, supporting various filtering conditions and log type selection.

💡 Request Example:

```
const response = await fetch('/api/log/?p=1&page_size=20&type=2&start_timestamp=1640908800&end_timestamp=1640995200&username=testuser&token_name=api_token&model_name=gpt-4&channel=1&group=default', {  
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
        "user_id": 1,  
        "created_at": 1640995000,  
        "type": 2,  
        "content": "API调用成功",  
        "username": "testuser",  
        "token_name": "api_token",  
        "model_name": "gpt-4",  
        "quota": 1000,  
        "prompt_tokens": 50,  
        "completion_tokens": 100,  
        "use_time": 2,  
        "is_stream": false,  
        "channel_id": 1,  
        "channel_name": "OpenAI渠道",  
        "token_id": 1,  
        "group": "default",  
        "ip": "192.168.1.1",  
        "other": "{\"model_ratio\":15.0}"  
      }  
    ],  
    "total": 100,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve logs"  
}
```

🧾 Field Description:

- `p` (Number): Page number, default is 1
- `page_size` (Number): Items per page, default is 20
- `type` (Number): Log type. Optional values: 1=Recharge, 2=Consumption, 3=Management, 4=Error, 5=System log.go：41-48
- `start_timestamp` (Number): Start timestamp
- `end_timestamp` (Number): End timestamp
- `username` (String): Filter by username
- `token_name` (String): Filter by Token name
- `model_name` (String): Filter by Model name
- `channel` (Number): Filter by Channel ID
- `group` (String): Filter by Group

### Delete Historical Logs

- **Interface Name**: Delete Historical Logs
- **HTTP Method**: DELETE
- **Path**: `/api/log/`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch delete historical log records older than the specified timestamp, supporting staged deletion to avoid excessive database load.

💡 Request Example:

```
const response = await fetch('/api/log/?target_timestamp=1640908800', {  
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
  "data": 1500  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "target timestamp is required"  
}
```

🧾 Field Description:

- `target_timestamp` (Number): Target timestamp. All logs before this time will be deleted, required.
- `data` (Number): Number of successfully deleted log entries.

### Log Statistics

- **Interface Name**: Log Statistics
- **HTTP Method**: GET
- **Path**: `/api/log/stat`
- **Authentication Requirement**: Administrator
- **Function Description**: Retrieve log statistics for the specified time range and conditions, including quota consumption, request frequency, and Token usage.

💡 Request Example:

```
const response = await fetch('/api/log/stat?type=2&start_timestamp=1640908800&end_timestamp=1640995200&username=testuser&token_name=api_token&model_name=gpt-4&channel=1&group=default', {  
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
    "quota": 150000,  
    "rpm": 25,  
    "tpm": 3500  
  }  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve statistics"  
}
```

🧾 Field Description:

- Request parameters are the same as the Get All Logs interface.
- `quota` (Number): Total quota consumption within the specified time range.
- `rpm` (Number): Requests Per Minute (last 60 seconds) log.go：357
- `tpm` (Number): Tokens Per Minute (sum of prompt_tokens + completion_tokens in the last 60 seconds).

### Search All Logs

- **Interface Name**: Search All Logs
- **HTTP Method**: GET
- **Path**: `/api/log/search`
- **Authentication Requirement**: Administrator
- **Function Description**: Search all log records in the system based on keywords.

💡 Request Example:

```
const response = await fetch('/api/log/search?keyword=error', {  
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
    {  
      "id": 1,  
      "type": 4,  
      "content": "API调用错误",  
      "username": "testuser",  
      "created_at": 1640995000  
    }  
  ]  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to search logs"  
}
```

🧾 Field Description:

`keyword` (String): Search keyword, can match log type or content.