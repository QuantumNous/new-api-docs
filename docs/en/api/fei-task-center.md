## 核心概念 (Core Concepts)

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API访问凭证，也指模型处理的文本单元 | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# Task Center Module

!!! info "Feature Description"
    The unified API prefix is http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A general asynchronous task management system. Primarily supports music generation tasks for platforms like Suno. Includes mechanisms such as automatic task status updates, failure retries, and quota refunds.

## 🔐 User Authentication

### Get My Tasks

- **API Name**：Get My Tasks
- **HTTP Method**：GET
- **Path**：`/api/task/self`
- **Authentication Requirement**：User
- **Feature Summary**：Paginates and retrieves the current user's task list, supporting filtering by platform, task ID, status, and other conditions

💡 Request Example:

```
const response = await fetch('/api/task/self?p=1&page_size=20&platform=suno&task_id=task123&status=SUCCESS&action=song&start_timestamp=1640908800&end_timestamp=1640995200', {  
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
        "created_at": 1640908800,  
        "updated_at": 1640909000,  
        "task_id": "task123456",  
        "platform": "suno",  
        "user_id": 1,  
        "quota": 1000,  
        "action": "song",  
        "status": "SUCCESS",  
        "fail_reason": "",  
        "submit_time": 1640908800,  
        "start_time": 1640908900,  
        "finish_time": 1640909000,  
        "progress": "100%",  
        "properties": {},  
        "data": {}  
      }  
    ],  
    "total": 25,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取任务列表失败"  
}
```

🧾 Field Descriptions (Request Parameters):

- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20
- `platform` (String): Task platform, optional
- `task_id` (String): Task ID filter, optional
- `status` (String): Task status filter, optional values: "NOT_START", "SUBMITTED", "QUEUED", "IN_PROGRESS", "FAILURE", "SUCCESS", "UNKNOWN"
- `action` (String): Task type filter, such as "song", "lyrics", etc.
- `start_timestamp` (Number): Start timestamp, optional
- `end_timestamp` (Number): End timestamp, optional

🧾 Return Field Descriptions:

- `id` (Number): Database record ID
- `task_id` (String): Third-party task ID
- `platform` (String): Task platform
- `user_id` (Number): User ID
- `quota` (Number): Consumed quota
- `action` (String): Task type
- `status` (String): Task status
- `fail_reason` (String): Failure reason
- `submit_time` (Number): Submission timestamp
- `start_time` (Number): Start timestamp
- `finish_time` (Number): Completion timestamp
- `progress` (String): Progress percentage
- `properties` (Object): Task properties
- `data` (Object): Task result data
- `total` (Number): Total number of matching task records
- `page` (Number): Current returned page number
- `page_size` (Number): Number of task records displayed per page

## 🔐 Administrator Authentication

### Get All Tasks

- **API Name**：Get All Tasks
- **HTTP Method**：GET
- **Path**：`/api/task/`
- **Authentication Requirement**：Administrator
- **Feature Summary**：Paginates and retrieves all tasks in the system, supporting filtering by channel ID, platform, user ID, and other conditions

💡 Request Example:

```
const response = await fetch('/api/task/?p=1&page_size=20&channel_id=1&platform=suno&task_id=task123&status=SUCCESS&action=song&start_timestamp=1640908800&end_timestamp=1640995200', {  
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
        "created_at": 1640908800,  
        "task_id": "task123456",  
        "platform": "suno",  
        "user_id": 1,  
        "channel_id": 1,  
        "quota": 1000,  
        "action": "song",  
        "status": "SUCCESS",  
        "submit_time": 1640908800,  
        "finish_time": 1640909000,  
        "progress": "100%",  
        "data": {}  
      }  
    ],  
    "total": 100,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取任务列表失败"  
}
```

🧾 Field Descriptions (Request Parameters):

- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20
- `channel_id` (String): Channel ID filter, optional
- `platform` (String): Task platform filter, optional
- `task_id` (String): Task ID filter, optional
- `status` (String): Task status filter, optional
- `action` (String): Task type filter, optional
- `start_timestamp` (Number): Start timestamp, optional
- `end_timestamp` (Number): End timestamp, optional
- The return fields include all fields from user tasks, plus the following addition:

    - `channel_id` (Number): Used channel ID