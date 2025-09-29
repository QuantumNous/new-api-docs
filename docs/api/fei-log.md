# 日志模块

!!! info "功能说明"
    接口前缀统一为 https://`<your-domain>`

    分层的日志查询系统，支持管理员查看全站日志和用户查看个人日志 。提供实时统计（RPM/TPM）、多维度过滤、历史数据清理等功能。支持 CORS 的 Token 查询接口便于第三方集成。

## 🔐 无需鉴权


### 根据 Token 查询日志

- **接口名称**：根据 Token 查询日志
- **HTTP 方法**：GET
- **路径**：`/api/log/token`
- **鉴权要求**：公开
- **功能简介**：通过 Token 密钥查询相关日志记录，支持跨域访问

💡 请求示例：

```
const response = await fetch('/api/log/token?key=sk-1234567890abcdef', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "Token不存在或无权限"  
}
```

🧾 字段说明：

`key` （字符串）: Token 密钥，必填

## 🔐 用户鉴权

### 我的日志统计

- **接口名称**：我的日志统计
- **HTTP 方法**：GET
- **路径**：`/api/log/self/stat`
- **鉴权要求**：用户
- **功能简介**：获取当前用户的日志统计信息，包括配额消耗、请求频率和 Token 使用量

💡 请求示例：

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

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取统计信息失败"  
}
```

🧾 字段说明：

- `type` （数字）: 日志类型，可选值：1=充值，2=消费，3=管理，4=错误，5=系统
- `start_timestamp` （数字）: 开始时间戳
- `end_timestamp` （数字）: 结束时间戳
- `token_name` （字符串）: Token 名称过滤
- `model_name` （字符串）: 模型名称过滤
- `group` （字符串）: 分组过滤
- `quota` （数字）: 指定时间范围内的总配额消耗
- `rpm` （数字）: 每分钟请求数（最近 60 秒）
- `tpm` （数字）: 每分钟 Token 数（最近 60 秒）

### 获取我的日志

- **接口名称**：获取我的日志
- **HTTP 方法**：GET
- **路径**：`/api/log/self`
- **鉴权要求**：用户
- **功能简介**：分页获取当前用户的日志记录，支持多种过滤条件

💡 请求示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取日志失败"  
}
```

🧾 字段说明：

请求参数与获取全部日志接口相同，但只返回当前用户的日志记录

### 搜索我的日志

- **接口名称**：搜索我的日志
- **HTTP 方法**：GET
- **路径**：`/api/log/self/search`
- **鉴权要求**：用户
- **功能简介**：根据关键词搜索当前用户的日志记录

💡 请求示例：

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

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "搜索日志失败"  
}
```

🧾 字段说明：

`keyword` （字符串）: 搜索关键词，匹配当前用户的日志类型

## 🔐 管理员鉴权

### 获取全部日志

- **接口名称**：获取全部日志
- **HTTP 方法**：GET
- **路径**：`/api/log/`
- **鉴权要求**：管理员
- **功能简介**：分页获取系统中所有日志记录，支持多种过滤条件和日志类型筛选

💡 请求示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取日志失败"  
}
```

🧾 字段说明：

- `p` （数字）: 页码，默认为 1
- `page_size` （数字）: 每页数量，默认为 20
- `type` （数字）: 日志类型，可选值：1=充值，2=消费，3=管理，4=错误，5=系统 log.go：41-48
- `start_timestamp` （数字）: 开始时间戳
- `end_timestamp` （数字）: 结束时间戳
- `username` （字符串）: 用户名过滤
- `token_name` （字符串）: Token 名称过滤
- `model_name` （字符串）: 模型名称过滤
- `channel` （数字）: 渠道 ID 过滤
- `group` （字符串）: 分组过滤

###  删除历史日志

- **接口名称**：删除历史日志
- **HTTP 方法**：DELETE
- **路径**：`/api/log/`
- **鉴权要求**：管理员
- **功能简介**：批量删除指定时间戳之前的历史日志记录，支持分批删除以避免数据库负载过高

💡 请求示例：

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

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "",  
  "data": 1500  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "target timestamp is required"  
}
```

🧾 字段说明：

- `target_timestamp` （数字）: 目标时间戳，删除此时间之前的所有日志，必填
- `data` （数字）: 成功删除的日志条数

### 日志统计

- **接口名称**：日志统计
- **HTTP 方法**：GET
- **路径**：`/api/log/stat`
- **鉴权要求**：管理员
- **功能简介**：获取指定时间范围和条件下的日志统计信息，包括配额消耗、请求频率和 Token 使用量

💡 请求示例：

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

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取统计信息失败"  
}
```

🧾 字段说明：

- 请求参数与获取全部日志接口相同
- `quota` （数字）: 指定时间范围内的总配额消耗
- `rpm` （数字）: 每分钟请求数（最近 60 秒） log.go：357
- `tpm` （数字）: 每分钟 Token 数（最近 60 秒的 prompt_tokens + completion_tokens 总和）

### 搜索全部日志

- **接口名称**：搜索全部日志
- **HTTP 方法**：GET
- **路径**：`/api/log/search`
- **鉴权要求**：管理员
- **功能简介**：根据关键词搜索系统中所有日志记录

💡 请求示例：

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

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "搜索日志失败"  
}
```

🧾 字段说明：

`keyword` （字符串）: 搜索关键词，可匹配日志类型或内容