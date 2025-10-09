# Midjourney 任务模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    图像生成任务的管理系统 。支持任务状态跟踪、进度监控、结果查看等功能。包含图片 URL 转发和后台轮询更新机制。

## 🔐 用户鉴权

###  获取自己的 MJ 任务

- **接口名称**：获取自己的 MJ 任务
- **HTTP 方法**：GET
- **路径**：`/api/mj/self`
- **鉴权要求**：用户
- **功能简介**：分页获取当前用户的 Midjourney 任务列表，支持按任务 ID 和时间范围过滤

💡 请求示例：

```
const response = await fetch('/api/mj/self?p=1&page_size=20&mj_id=task123&start_timestamp=1640908800&end_timestamp=1640995200', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取任务列表失败"  
}
```

🧾 字段说明：

- `p` （数字）: 页码，默认为 1
- `page_size` （数字）: 每页数量，默认为 20
- `mj_id` （字符串）: 任务 ID 过滤，可选 
- `start_timestamp` （数字）: 开始时间戳，可选
- `end_timestamp` （数字）: 结束时间戳，可选
- 返回字段说明：

    - `id` （数字）: 数据库记录 ID
    - `mj_id` （字符串）: Midjourney 任务唯一标识符 
    - `action` （字符串）: 操作类型，如 IMAGINE、UPSCALE 等 
    - `prompt` （字符串）: 原始提示词
    - `prompt_en` （字符串）: 英文提示词
    - `status` （字符串）: 任务状态 midjourney.go：19
    - `progress` （字符串）: 完成进度百分比 
    - `image_url` （字符串）: 生成的图片 URL
    - `video_url` （字符串）: 生成的视频 URL
    - `video_urls` （字符串）: 多个视频 URL 的 JSON 数组字符串 
    - `submit_time` （数字）: 提交时间戳
    - `start_time` （数字）: 开始处理时间戳
    - `finish_time` （数字）: 完成时间戳
    - `fail_reason` （字符串）: 失败原因
    - `quota` （数字）: 消耗的配额

## 🔐 管理员鉴权

### 获取全部 MJ 任务

- **接口名称**：获取全部 MJ 任务
- **HTTP 方法**：GET
- **路径**：`/api/mj/`
- **鉴权要求**：管理员
- **功能简介**：分页获取系统中所有 Midjourney 任务，支持按渠道 ID、任务 ID 和时间范围过滤

💡 请求示例：

```
const response = await fetch('/api/mj/?p=1&page_size=20&channel_id=1&mj_id=task123&start_timestamp=1640908800&end_timestamp=1640995200', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取任务列表失败"  
}
```

🧾 字段说明：

- `p` （数字）: 页码，默认为 1
- `page_size` （数字）: 每页数量，默认为 20
- `channel_id` （字符串）: 渠道 ID 过滤，可选 
- `mj_id` （字符串）: 任务 ID 过滤，可选
- `start_timestamp` （字符串）: 开始时间戳，可选
- `end_timestamp` （字符串）: 结束时间戳，可选
- 返回字段包含用户自身任务的所有字段，另外增加：

    - `user_id` （数字）: 任务所属用户 ID 
    - `channel_id` （数字）: 使用的渠道 ID 
