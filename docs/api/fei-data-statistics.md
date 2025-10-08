# 数据统计模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    用量数据的聚合统计系统 。管理员可查看全站统计，用户可查看个人统计。数据按模型和日期分组，用于生成图表和报表，监控系统使用趋势。

## 🔐 用户鉴权

### 我的用量按日期统计

- **接口名称**：我的用量按日期统计
- **HTTP 方法**：GET
- **路径**：`/api/data/self`
- **鉴权要求**：用户
- **功能简介**：获取当前用户的用量数据按日期统计，支持时间范围查询

💡 请求示例：

```
const response = await fetch('/api/data/self?start_timestamp=1640908800&end_timestamp=1640995200', {  
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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取个人统计数据失败"  
}
```

🧾 字段说明：

- `start_timestamp` （数字）: 开始时间戳，可选
- `end_timestamp` （数字）: 结束时间戳，可选
- `data` （数组）: 个人统计数据列表 

    - `model_name` （字符串）: 模型名称
    - `count` （数字）: 请求次数
    - `quota` （数字）: 配额消耗
    - `token_used` （数字）: Token 使用量
    - `created_at` （数字）: 统计日期时间戳
    - `user_id` （数字）: 用户 ID
    - `username` （字符串）: 用户名

## 🔐 管理员鉴权

### 全站用量按日期统计

- **接口名称**：全站用量按日期统计
- **HTTP 方法**：GET
- **路径**：`/api/data/`
- **鉴权要求**：管理员
- **功能简介**：获取系统全站用量数据按日期统计，支持按用户名过滤和时间范围查询

💡 请求示例：

```
const response = await fetch('/api/data/?start_timestamp=1640908800&end_timestamp=1640995200&username=testuser', {  
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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取统计数据失败"  
}
```

🧾 字段说明：

- `start_timestamp` （数字）: 开始时间戳，可选
- `end_timestamp` （数字）: 结束时间戳，可选
- `username` （字符串）: 用户名过滤，可选 
- `data` （数组）: 统计数据列表，按模型和日期分组聚合 

    - `model_name` （字符串）: 模型名称
    - `count` （数字）: 请求次数总和
    - `quota` （数字）: 配额消耗总和
    - `token_used` （数字）: Token 使用量总和
    - `created_at` （数字）: 统计日期时间戳