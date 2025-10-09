# 公共信息模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    提供无需认证或低权限访问的系统信息，包括模型列表、定价信息、公告内容等。支持多语言显示和动态配置 。前端首页和模型广场主要依赖这些接口获取展示数据。

## 🔐 无需鉴权

### 获取公告栏内容

- **接口名称**：获取公告栏内容
- **HTTP 方法**：GET
- **路径**：`/api/notice`
- **鉴权要求**：公开
- **功能简介**：获取系统公告内容，支持 Markdown 格式

💡 请求示例：

```
const response = await fetch('/api/notice', {  
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
  "data": "# 系统公告\n\n欢迎使用New API系统！"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取公告失败"  
}
```

🧾 字段说明：

`data` （字符串）: 公告内容，支持 Markdown 格式

### 关于页面信息

- **接口名称**：关于页面信息
- **HTTP 方法**：GET
- **路径**：`/api/about`
- **鉴权要求**：公开
- **功能简介**：获取关于页面的自定义内容

💡 请求示例：

```
const response = await fetch('/api/about', {  
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
  "data": "# 关于我们\n\nNew API是一个强大的AI网关系统..."  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取关于信息失败"  
}
```

🧾 字段说明：

`data` （字符串）: 关于页面内容，支持 Markdown 格式或 URL 链接

### 首页自定义内容

- **接口名称**：首页自定义内容
- **HTTP 方法**：GET
- **路径**：`/api/home_page_content`
- **鉴权要求**：公开
- **功能简介**：获取首页的自定义内容，可以是 Markdown 文本或 iframe URL

💡 请求示例：

```
const response = await fetch('/api/home_page_content', {  
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
  "data": "# 欢迎使用New API\n\n这是一个功能强大的AI网关系统..."  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取首页内容失败"  
}
```

🧾 字段说明：

`data` （字符串）: 首页内容，可以是 Markdown 文本或以"https://"开头的 URL 链接

### 模型倍率配置

- **接口名称**：模型倍率配置
- **HTTP 方法**：GET
- **路径**：`/api/ratio_config`
- **鉴权要求**：公开
- **功能简介**：获取公开的模型倍率配置信息，用于上游系统同步

💡 请求示例：

```
const response = await fetch('/api/ratio_config', {  
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
  "data": {  
    "model_ratio": {  
      "gpt-3.5-turbo": 1.0,  
      "gpt-4": 15.0,  
      "claude-3-sonnet": 3.0  
    },  
    "completion_ratio": {  
      "gpt-3.5-turbo": 1.0,  
      "gpt-4": 1.0  
    },  
    "model_price": {  
      "gpt-3.5-turbo-instruct": 0.002  
    }  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取倍率配置失败"  
}
```

🧾 字段说明：

`data` （对象）: 倍率配置信息

- `model_ratio` （对象）: 模型倍率映射，键为模型名，值为倍率数值
- `completion_ratio` （对象）: 补全倍率映射
- `model_price` （对象）: 模型价格映射，键为模型名，值为价格（美元）

### 价格与套餐信息

- **接口名称**：价格与套餐信息
- **HTTP 方法**：GET
- **路径**：`/api/pricing`
- **鉴权要求**：可匿名/用户
- **功能简介**：获取模型定价信息、分组倍率和可用分组

💡 请求示例：

```
const response = await fetch('/api/pricing', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_token', // 可选，登录用户可获得更详细信息
    'New-Api-User': 'Bearer your_user_id' // 可选
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "data": [  
    {  
      "model_name": "gpt-3.5-turbo",  
      "enable_group": ["default", "vip"],  
      "model_ratio": 1.0,  
      "completion_ratio": 1.0,  
      "model_price": 0.002,  
      "quota_type": 1,  
      "description": "GPT-3.5 Turbo模型",  
      "vendor_id": 1,  
      "supported_endpoint_types": [1, 2]  
    }  
  ],  
  "vendors": [  
    {  
      "id": 1,  
      "name": "OpenAI",  
      "description": "OpenAI官方模型",  
      "icon": "openai.png"  
    }  
  ],  
  "group_ratio": {  
    "default": 1.0,  
    "vip": 0.8  
  },  
  "usable_group": {  
    "default": "默认分组",  
    "vip": "VIP分组"  
  },  
  "supported_endpoint": {  
    "1": {"method": "POST", "path": "/v1/chat/completions"},  
    "2": {"method": "POST", "path": "/v1/embeddings"}  
  },  
  "auto_groups": ["default"]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取定价信息失败"  
}
```

🧾 字段说明：

- `data` （数组）: 模型定价信息列表 

    - `model_name` （字符串）: 模型名称
    - `enable_group` （数组）: 可用分组列表
    - `model_ratio` （数字）: 模型倍率
    - `completion_ratio` （数字）: 补全倍率
    - `model_price` （数字）: 模型价格（美元）
    - `quota_type` （数字）: 计费类型，0=倍率计费，1=价格计费
    - `description` （字符串）: 模型描述
    - `vendor_id` （数字）: 供应商 ID
    - `supported_endpoint_types` （数组）: 支持的端点类型
- `vendors` （数组）: 供应商信息列表 

    - `id` （数字）: 供应商 ID
    - `name` （字符串）: 供应商名称
    - `description` （字符串）: 供应商描述
    - `icon` （字符串）: 供应商图标
- `group_ratio` （对象）: 分组倍率映射
- `usable_group` （对象）: 可用分组映射
- `supported_endpoint` （对象）: 支持的端点信息
- `auto_groups` （数组）: 自动分组列表

## 🔐 用户鉴权

### 获取前端可用模型列表

- **接口名称**：获取前端可用模型列表
- **HTTP 方法**：GET
- **路径**：`/api/models`
- **鉴权要求**：用户
- **功能简介**：获取当前用户可访问的 AI 模型列表，用于前端 Dashboard 展示

💡 请求示例：

```
const response = await fetch('/api/models', {  
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
  "data": {  
    "1": ["gpt-3.5-turbo", "gpt-4"],  
    "2": ["claude-3-sonnet", "claude-3-haiku"]  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "未授权访问"  
}
```

🧾 字段说明：

`data` （对象）: 渠道 ID 到模型列表的映射

- 键 （字符串）: 渠道 ID
- 值 （数组）: 该渠道支持的模型名称列表