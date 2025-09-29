# 兑换码管理模块

!!! info "功能说明"
    接口前缀统一为 https://`<your-domain>`

    管理员专用的兑换码系统 。支持批量生成、状态管理、搜索过滤等功能。包含自动清理无效兑换码的维护功能。主要用于促销活动和用户激励。

## 🔐 管理员鉴权


### 获取兑换码列表

- **接口名称**：获取兑换码列表
- **HTTP 方法**：GET
- **路径**：`/api/redemption/`
- **鉴权要求**：管理员
- **功能简介**：分页获取系统中所有兑换码的列表信息

💡 请求示例：

```
const response = await fetch('/api/redemption/?p=1&page_size=20', {  
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
        "name": "新年活动兑换码",  
        "key": "abc123def456",  
        "status": 1,  
        "quota": 100000,  
        "created_time": 1640908800,  
        "redeemed_time": 0,  
        "expired_time": 1640995200,  
        "used_user_id": 0  
      }  
    ],  
    "total": 50,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取兑换码列表失败"  
}
```

🧾 字段说明：

- `p` （数字）: 页码，默认为 1
- `page_size` （数字）: 每页数量，默认为 20
- `items` （数组）: 兑换码信息列表 
- `total` （数字）: 兑换码总数
- `page` （数字）: 当前页码
- `page_size` （数字）: 每页数量

### 搜索兑换码

- **接口名称**：搜索兑换码
- **HTTP 方法**：GET
- **路径**：`/api/redemption/search`
- **鉴权要求**：管理员
- **功能简介**：根据关键词搜索兑换码，支持按 ID 和名称搜索

💡 请求示例：

```
const response = await fetch('/api/redemption/search?keyword=新年&p=1&page_size=20', {  
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
        "name": "新年活动兑换码",  
        "key": "abc123def456",  
        "status": 1,  
        "quota": 100000  
      }  
    ],  
    "total": 1,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "搜索兑换码失败"  
}
```

🧾 字段说明：

- `keyword` （字符串）: 搜索关键词，可匹配兑换码名称或 ID 
- `p` （数字）: 页码，默认为 1
- `page_size` （数字）: 每页数量，默认为 20

### 获取单个兑换码

- **接口名称**：获取单个兑换码
- **HTTP 方法**：GET
- **路径**：`/api/redemption/:id`
- **鉴权要求**：管理员
- **功能简介**：获取指定兑换码的详细信息

💡 请求示例：

```
const response = await fetch('/api/redemption/123', {  
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
    "id": 123,  
    "name": "新年活动兑换码",  
    "key": "abc123def456",  
    "status": 1,  
    "quota": 100000,  
    "created_time": 1640908800,  
    "redeemed_time": 0,  
    "expired_time": 1640995200,  
    "used_user_id": 0,  
    "user_id": 1  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "兑换码不存在"  
}
```

🧾 字段说明：

`id` （数字）: 兑换码 ID，通过 URL 路径传递

### 创建兑换码

- **接口名称**：创建兑换码
- **HTTP 方法**：POST
- **路径**：`/api/redemption/`
- **鉴权要求**：管理员
- **功能简介**：批量创建兑换码，支持一次创建多个

💡 请求示例：

```
const response = await fetch('/api/redemption/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    name: "春节活动兑换码",  
    count: 10,  
    quota: 100000,  
    expired_time: 1640995200  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    "abc123def456",  
    "def456ghi789",  
    "ghi789jkl012"  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "兑换码名称长度必须在1-20之间"  
}
```

🧾 字段说明：

- `name` （字符串）: 兑换码名称，长度必须在 1-20 个字符之间 
- `count` （数字）: 要创建的兑换码数量，必须大于 0 且不超过 100 
- `quota` （数字）: 每个兑换码的配额数量
- `expired_time` （数字）: 过期时间戳，0 表示永不过期 
- `data` （数组）: 成功创建的兑换码列表

###  更新兑换码

- **接口名称**：更新兑换码
- **HTTP 方法**：PUT
- **路径**：`/api/redemption/`
- **鉴权要求**：管理员
- **功能简介**：更新兑换码信息，支持仅更新状态或完整更新

💡 请求示例（完整更新）：

```
const response = await fetch('/api/redemption/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    name: "更新的兑换码名称",  
    quota: 200000,  
    expired_time: 1672531200  
  })  
});  
const data = await response.json();
```

💡 请求示例（仅更新状态）：

```
const response = await fetch('/api/redemption/?status_only=true', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    status: 2  
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
    "name": "更新的兑换码名称",  
    "status": 1,  
    "quota": 200000,  
    "expired_time": 1672531200  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "过期时间不能早于当前时间"  
}
```

🧾 字段说明：

- `id` （数字）: 兑换码 ID，必填
- `status_only` （查询参数）: 是否仅更新状态 
- `name` （字符串）: 兑换码名称，可选
- `quota` （数字）: 配额数量，可选
- `expired_time` （数字）: 过期时间戳，可选
- `status` （数字）: 兑换码状态，可选

### 删除无效兑换码

- **接口名称**：删除无效兑换码
- **HTTP 方法**：DELETE
- **路径**：`/api/redemption/invalid`
- **鉴权要求**：管理员
- **功能简介**：批量删除已使用、已禁用或已过期的兑换码

💡 请求示例：

```
const response = await fetch('/api/redemption/invalid', {  
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
  "data": 15  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "删除失败"  
}
```

🧾 字段说明：

- 无请求参数
- `data` （数字）: 删除的兑换码数量

### 删除兑换码

- **接口名称**：删除兑换码
- **HTTP 方法**：DELETE
- **路径**：`/api/redemption/:id`
- **鉴权要求**：管理员
- **功能简介**：删除指定的兑换码

💡 请求示例：

```
const response = await fetch('/api/redemption/123', {  
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
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "兑换码不存在"  
}
```

🧾 字段说明：

`id` （数字）: 兑换码 ID，通过 URL 路径传递
