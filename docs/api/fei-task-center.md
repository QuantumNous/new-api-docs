# 任务中心模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    通用异步任务管理系统 。主要支持 Suno 等平台的音乐生成任务。包含任务状态自动更新、失败重试、配额退还等机制。

## 🔐 用户鉴权

### 获取我的任务

- **接口名称**：获取我的任务
- **HTTP 方法**：GET
- **路径**：`/api/task/self`
- **鉴权要求**：用户
- **功能简介**：分页获取当前用户的任务列表，支持按平台、任务 ID、状态等条件过滤

💡 请求示例：

```
const response = await fetch('/api/task/self?p=1&page_size=20&platform=suno&task_id=task123&status=SUCCESS&action=song&start_timestamp=1640908800&end_timestamp=1640995200', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
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
- `platform` （字符串）: 任务平台，可选 
- `task_id` （字符串）: 任务 ID 过滤，可选 
- `status` （字符串）: 任务状态过滤，可选值："NOT_START"、"SUBMITTED"、"QUEUED"、"IN_PROGRESS"、"FAILURE"、"SUCCESS"、"UNKNOWN" 
- `action` （字符串）: 任务类型过滤，如"song"、"lyrics"等 
- `start_timestamp` （数字）: 开始时间戳，可选
- `end_timestamp` （数字）: 结束时间戳，可选

🧾 返回字段说明：

- `id` （数字）: 数据库记录 ID 
- `task_id` （字符串）: 第三方任务 ID
- `platform` （字符串）: 任务平台
- `user_id` （数字）: 用户 ID
- `quota` （数字）: 消耗的配额 
- `action` （字符串）: 任务类型
- `status` （字符串）: 任务状态
- `fail_reason` （字符串）: 失败原因 
- `submit_time` （数字）: 提交时间戳
- `start_time` （数字）: 开始时间戳
- `finish_time` （数字）: 完成时间戳
- `progress` （字符串）: 进度百分比 
- `properties` （对象）: 任务属性 
- `data` （对象）: 任务结果数据 
- `total` （数字）: 符合条件的任务总记录数
- `page` （数字）: 当前返回的页码
- `page_size` （数字）: 每页展示的任务记录数

## 🔐 管理员鉴权

### 获取全部任务

- **接口名称**：获取全部任务
- **HTTP 方法**：GET
- **路径**：`/api/task/`
- **鉴权要求**：管理员
- **功能简介**：分页获取系统中所有任务，支持按渠道 ID、平台、用户 ID 等条件过滤

💡 请求示例：

```
const response = await fetch('/api/task/?p=1&page_size=20&channel_id=1&platform=suno&task_id=task123&status=SUCCESS&action=song&start_timestamp=1640908800&end_timestamp=1640995200', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
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
- `platform` （字符串）: 任务平台过滤，可选
- `task_id` （字符串）: 任务 ID 过滤，可选
- `status` （字符串）: 任务状态过滤，可选
- `action` （字符串）: 任务类型过滤，可选
- `start_timestamp` （数字）: 开始时间戳，可选
- `end_timestamp` （数字）: 结束时间戳，可选
- 返回字段包含用户任务的所有字段，另外增加：

    - `channel_id` （数字）: 使用的渠道 ID 