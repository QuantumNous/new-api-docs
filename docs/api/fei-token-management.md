# Token 管理模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    用户 API Token 的完整管理系统 。支持 Token 创建、更新、删除、批量操作等功能。包含模型限制、IP 限制、配额管理、过期时间等精细化控制。前端 Token 页面的核心数据来源。

## 🔐 用户鉴权

### 获取全部 Token

- **接口名称**：获取全部 Token
- **HTTP 方法**：GET
- **路径**：`/api/token/`
- **鉴权要求**：用户
- **功能简介**：分页获取当前用户的所有 Token 列表

💡 请求示例：

```
const response = await fetch('/api/token/?p=1&size=20', {  
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
        "name": "API Token",  
        "key": "<YOUR_API_KEY>",  
        "status": 1,  
        "remain_quota": 1000000,  
        "unlimited_quota": false,  
        "expired_time": 1640995200,  
        "created_time": 1640908800,  
        "accessed_time": 1640995000  
      }  
    ],  
    "total": 5,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取Token列表失败"  
}
```

🧾 字段说明：

- `p` （数字）: 页码，默认为 1
- `size` （数字）: 每页数量，默认为 20
- `items` （数组）: Token 信息列表
- `total` （数字）: Token 总数
- `page` （数字）: 当前页码
- `page_size` （数字）: 每页数量

### 搜索 Token

- **接口名称**：搜索 Token
- **HTTP 方法**：GET
- **路径**：`/api/token/search`
- **鉴权要求**：用户
- **功能简介**：根据关键词和 Token 值搜索用户的 Token

💡 请求示例：

```
const response = await fetch('/api/token/search?keyword=api&token=sk-123', {  
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
      "name": "API Token",  
      "key": "sk-your-token-placeholder",  
      "status": 1,  
      "remain_quota": 1000000  
    }  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "搜索Token失败"  
}
```

🧾 字段说明：

- `keyword` （字符串）: 搜索关键词，匹配 Token 名称
- `token` （字符串）: Token 值搜索，支持部分匹配 

### 获取单个 Token

- **接口名称**：获取单个 Token
- **HTTP 方法**：GET
- **路径**：`/api/token/:id`
- **鉴权要求**：用户
- **功能简介**：获取指定 Token 的详细信息

💡 请求示例：

```
const response = await fetch('/api/token/123', {  
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
    "id": 123,  
    "name": "API Token",  
    "key": "sk-your-token-placeholder",  
    "status": 1,  
    "remain_quota": 1000000,  
    "unlimited_quota": false,  
    "model_limits_enabled": true,  
    "model_limits": "gpt-3.5-turbo,gpt-4",  
    "allow_ips": "192.168.1.1,10.0.0.1",  
    "group": "default",  
    "expired_time": 1640995200,  
    "created_time": 1640908800,  
    "accessed_time": 1640995000  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "Token不存在"  
}
```

🧾 字段说明：

`id` （数字）: Token ID，通过 URL 路径传递

### 创建 Token

- **接口名称**：创建 Token
- **HTTP 方法**：POST
- **路径**：`/api/token/`
- **鉴权要求**：用户
- **功能简介**：创建新的 API Token，支持批量创建

💡 请求示例：

```
const response = await fetch('/api/token/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    name: "My API Token",  
    expired_time: 1640995200,  
    remain_quota: 1000000,  
    unlimited_quota: false,  
    model_limits_enabled: true,  
    model_limits: ["gpt-3.5-turbo", "gpt-4"],  
    allow_ips: "192.168.1.1,10.0.0.1",  
    group: "default"  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "令牌名称过长"  
}
```

🧾 字段说明：

- `name` （字符串）: Token 名称，最大长度 30 个字符 
- `expired_time` （数字）: 过期时间戳，-1 表示永不过期
- `remain_quota` （数字）: 剩余配额
- `unlimited_quota` （布尔型）: 是否无限配额
- `model_limits_enabled` （布尔型）: 是否启用模型限制
- `model_limits` （数组）: 允许使用的模型列表
- `allow_ips` （字符串）: 允许的 IP 地址，逗号分隔
- `group` （字符串）: 所属分组

### 更新 Token

- **接口名称**：更新 Token
- **HTTP 方法**：PUT
- **路径**：`/api/token/`
- **鉴权要求**：用户
- **功能简介**：更新 Token 配置，支持状态切换和完整更新

💡 请求示例（完整更新）：

```
const response = await fetch('/api/token/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    name: "Updated Token",  
    expired_time: 1640995200,  
    remain_quota: 2000000,  
    unlimited_quota: false,  
    model_limits_enabled: true,  
    model_limits: ["gpt-3.5-turbo", "gpt-4"],  
    allow_ips: "192.168.1.1",  
    group: "vip"  
  })  
});  
const data = await response.json();
```

💡 请求示例（仅更新状态）：

```
const response = await fetch('/api/token/?status_only=true', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    status: 1  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "id": 123,  
    "name": "Updated Token",  
    "status": 1  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "令牌已过期，无法启用，请先修改令牌过期时间，或者设置为永不过期"  
}
```

🧾 字段说明：

- `id` （数字）: Token ID，必填
- `status_only` （查询参数）: 是否仅更新状态 
- 其他字段与创建 Token 接口相同，均为可选

### 删除 Token

- **接口名称**：删除 Token
- **HTTP 方法**：DELETE
- **路径**：`/api/token/:id`
- **鉴权要求**：用户
- **功能简介**：删除指定的 Token

💡 请求示例：

```
const response = await fetch('/api/token/123', {  
  method: 'DELETE',  
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
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "Token不存在"  
}
```

🧾 字段说明：

`id` （数字）: Token ID，通过 URL 路径传递

### 批量删除 Token

- **接口名称**：批量删除 Token
- **HTTP 方法**：POST
- **路径**：`/api/token/batch`
- **鉴权要求**：用户
- **功能简介**：批量删除多个 Token

💡 请求示例：

```
const response = await fetch('/api/token/batch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    ids: [1, 2, 3, 4, 5]  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "",  
  "data": 5  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "参数错误"  
}
```

🧾 字段说明：

- `ids` （数组）: 要删除的 Token ID 列表，必填且不能为空 
- `data` （数字）: 成功删除的 Token 数量 
