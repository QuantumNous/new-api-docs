# Midjourney Task Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A management system for image generation tasks. Supports functions like task status tracking, progress monitoring, and result viewing. Includes image URL forwarding and a backend polling update mechanism.

## 🔐 User Authentication

### Get Own MJ Tasks

- **Interface Name**: Get Own MJ Tasks
- **HTTP Method**: GET
- **Path**: `/api/mj/self`
- **Authentication Requirement**: User
- **Function Summary**: Paginates the current user's Midjourney task list, supports filtering by task ID and time range

💡 Request Example:

```
const response = await fetch('/api/mj/self?p=1&page_size=20&mj_id=task123&start_timestamp=1640908800&end_timestamp=1640995200', {  
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
        "mj_id": "task123456",  
        "action": "IMAGINE",  
        "prompt": "a beautiful landscape",  
        "prompt_en": "a beautiful landscape",  
        "status": "SUCCESS",  
        "progress": "100%",  
        "image_url": "https://example.com/image.jpg",  
        "video_url": "https://example.com/video.mp4",  
        "video_urls": "[\"https://example.com/video1.mp4\"]",  
        "submit_time": 1640908800,  
        "start_time": 1640909000,  
        "finish_time": 1640909200,  
        "fail_reason": "",  
        "quota": 1000  
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
  "message": "Failed to retrieve task list"  
}
```

🧾 Field Descriptions:

- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20
- `mj_id` (String): Task ID filter, optional 
- `start_timestamp` (Number): Start timestamp, optional
- `end_timestamp` (Number): End timestamp, optional
- Description of returned fields:

    - `id` (Number): Database record ID
    - `mj_id` (String): Midjourney task unique identifier 
    - `action` (String): Operation type, such as IMAGINE, UPSCALE, etc. 
    - `prompt` (String): Original prompt
    - `prompt_en` (String): English prompt
    - `status` (String): Task status midjourney.go：19
    - `progress` (String): Completion progress percentage 
    - `image_url` (String): Generated image URL
    - `video_url` (String): Generated video URL
    - `video_urls` (String): JSON array string of multiple video URLs 
    - `submit_time` (Number): Submission timestamp
    - `start_time` (Number): Start processing timestamp
    - `finish_time` (Number): Completion timestamp
    - `fail_reason` (String): Failure reason
    - `quota` (Number): Consumed quota

## 🔐 Administrator Authentication

### Get All MJ Tasks

- **Interface Name**: Get All MJ Tasks
- **HTTP Method**: GET
- **Path**: `/api/mj/`
- **Authentication Requirement**: Administrator
- **Function Summary**: Paginates all Midjourney tasks in the system, supports filtering by channel ID, task ID, and time range

💡 Request Example:

```
const response = await fetch('/api/mj/?p=1&page_size=20&channel_id=1&mj_id=task123&start_timestamp=1640908800&end_timestamp=1640995200', {  
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
        "mj_id": "task123456",  
        "action": "IMAGINE",  
        "prompt": "a beautiful landscape",  
        "status": "SUCCESS",  
        "progress": "100%",  
        "image_url": "https://example.com/image.jpg",  
        "channel_id": 1,  
        "quota": 1000,  
        "submit_time": 1640908800,  
        "finish_time": 1640909200  
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
  "message": "Failed to retrieve task list"  
}
```

🧾 Field Descriptions:

- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20
- `channel_id` (String): Channel ID filter, optional 
- `mj_id` (String): Task ID filter, optional
- `start_timestamp` (String): Start timestamp, optional
- `end_timestamp` (String): End timestamp, optional
- The returned fields include all fields from the user's own tasks, plus the following additions:

    - `user_id` (Number): ID of the user owning the task 
    - `channel_id` (Number): ID of the channel used