# Data Statistics Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    An aggregated statistics system for usage data. Administrators can view site-wide statistics, and users can view personal statistics. Data is grouped by model and date, used to generate charts and reports, and monitor system usage trends.

## 🔐 User Authentication

### My Usage Statistics by Date

- **API Name**: My Usage Statistics by Date
- **HTTP Method**: GET
- **Path**: `/api/data/self`
- **Authentication Required**: User
- **Function Description**: Retrieves the current user's usage data aggregated by date, supporting time range queries.

💡 Request Example:

```
const response = await fetch('/api/data/self?start_timestamp=1640908800&end_timestamp=1640995200', {  
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
      "model_name": "gpt-3.5-turbo",  
      "count": 25,  
      "quota": 12500,  
      "token_used": 2000,  
      "created_at": 1640995200,  
      "user_id": 1,  
      "username": "testuser"  
    },  
    {  
      "model_name": "gpt-4",  
      "count": 10,  
      "quota": 30000,  
      "token_used": 1500,  
      "created_at": 1640995200,  
      "user_id": 1,  
      "username": "testuser"  
    }  
  ]  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve personal statistics data"  
}
```

🧾 Field Description:

- `start_timestamp` (Number): Start timestamp, optional
- `end_timestamp` (Number): End timestamp, optional
- `data` (Array): List of personal statistics data 

    - `model_name` (String): Model name
    - `count` (Number): Request count
    - `quota` (Number): Quota consumption
    - `token_used` (Number): Token usage
    - `created_at` (Number): Statistics date timestamp
    - `user_id` (Number): User ID
    - `username` (String): Username

## 🔐 Administrator Authentication

### Site-Wide Usage Statistics by Date

- **API Name**: Site-Wide Usage Statistics by Date
- **HTTP Method**: GET
- **Path**: `/api/data/`
- **Authentication Required**: Administrator
- **Function Description**: Retrieves system site-wide usage data aggregated by date, supporting filtering by username and time range queries.

💡 Request Example:

```
const response = await fetch('/api/data/?start_timestamp=1640908800&end_timestamp=1640995200&username=testuser', {  
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
    {  
      "model_name": "gpt-3.5-turbo",  
      "count": 150,  
      "quota": 75000,  
      "token_used": 12500,  
      "created_at": 1640995200  
    },  
    {  
      "model_name": "gpt-4",  
      "count": 50,  
      "quota": 150000,  
      "token_used": 8000,  
      "created_at": 1640995200  
    }  
  ]  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve statistics data"  
}
```

🧾 Field Description:

- `start_timestamp` (Number): Start timestamp, optional
- `end_timestamp` (Number): End timestamp, optional
- `username` (String): Username filter, optional 
- `data` (Array): List of statistics data, aggregated by model and date group 

    - `model_name` (String): Model name
    - `count` (Number): Total request count
    - `quota` (Number): Total quota consumption
    - `token_used` (Number): Total token usage
    - `created_at` (Number): Statistics date timestamp