# 渠道管理模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    AI 服务提供商渠道的完整管理系统 。支持渠道增删改查、批量操作、连通性测试、余额查询、标签管理等功能。包含模型能力同步和渠道复制等高级功能。

## 🔐 管理员鉴权


### 获取渠道列表

- **接口名称**：获取渠道列表
- **HTTP 方法**：GET
- **路径**：`/api/channel/`
- **鉴权要求**：管理员
- **功能简介**：分页获取系统中所有渠道的列表信息，支持按类型、状态过滤和标签模式

💡 请求示例：

```
const response = await fetch('/api/channel/?p=1&page_size=20&id_sort=false&tag_mode=false&type=1&status=enabled', {  
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
        "name": "OpenAI渠道",  
        "type": 1,  
        "status": 1,  
        "priority": 10,  
        "weight": 100,  
        "models": "gpt-3.5-turbo,gpt-4",  
        "group": "default",  
        "response_time": 1500,  
        "test_time": 1640995200  
      }  
    ],  
    "total": 50,  
    "type_counts": {  
      "1": 20,  
      "2": 15,  
      "all": 35  
    }  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取渠道列表失败"  
}
```

🧾 字段说明：

- `p` （数字）: 页码，默认为 1
- `page_size` （数字）: 每页数量，默认为 20
- `id_sort` （布尔型）: 是否按 ID 排序，默认按优先级排序
- `tag_mode` （布尔型）: 是否启用标签模式
- `type` （数字）: 渠道类型过滤
- `status` （字符串）: 状态过滤，可选值："enabled"、"disabled"、"all"

### 搜索渠道

- **接口名称**：搜索渠道
- **HTTP 方法**：GET
- **路径**：`/api/channel/search`
- **鉴权要求**：管理员
- **功能简介**：根据关键词、分组、模型等条件搜索渠道

💡 请求示例：

```
const response = await fetch('/api/channel/search?keyword=openai&group=default&model=gpt-4&id_sort=false&tag_mode=false&p=1&page_size=20&type=1&status=enabled', {  
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
        "name": "OpenAI官方渠道",  
        "type": 1,  
        "status": 1,  
        "models": "gpt-3.5-turbo,gpt-4",  
        "group": "default"  
      }  
    ],  
    "total": 1,  
    "type_counts": {  
      "1": 1,  
      "all": 1  
    }  
  }  
}
```

❗ 失败响应示例：

```
{    "success": false,    "message": "搜索渠道失败"  }
```

🧾 字段说明：

- `keyword` （字符串）: 搜索关键词，可匹配渠道名称
- `group` （字符串）: 分组过滤条件
- `model` （字符串）: 模型过滤条件
- 其他参数与获取渠道列表接口相同

### 查询渠道模型能力

- **接口名称**：查询渠道模型能力
- **HTTP 方法**：GET
- **路径**：`/api/channel/models`
- **鉴权要求**：管理员
- **功能简介**：获取系统中所有渠道支持的模型列表

💡 请求示例：

```
const response = await fetch('/api/channel/models', {  
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
      "id": "gpt-3.5-turbo",  
      "name": "GPT-3.5 Turbo"  
    },  
    {  
      "id": "gpt-4",  
      "name": "GPT-4"  
    },  
    {  
      "id": "claude-3-sonnet",  
      "name": "Claude 3 Sonnet"  
    }  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取模型列表失败"  
}
```

🧾 字段说明：

`data` （数组）: 模型信息列表

- `id` （字符串）: 模型 ID
- `name` （字符串）: 模型显示名称

### 查询启用模型能力

- **接口名称**：查询启用模型能力
- **HTTP 方法**：GET
- **路径**：`/api/channel/models_enabled`
- **鉴权要求**：管理员
- **功能简介**：获取当前启用渠道支持的模型列表

💡 请求示例：

```
const response = await fetch('/api/channel/models_enabled', {  
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
    "gpt-3.5-turbo",  
    "gpt-4",  
    "claude-3-sonnet"  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取启用模型失败"  
}
```

🧾 字段说明：

`data` （数组）: 启用的模型 ID 列表

### 获取单个渠道

- **接口名称**：获取单个渠道
- **HTTP 方法**：GET
- **路径**：`/api/channel/:id`
- **鉴权要求**：管理员
- **功能简介**：获取指定渠道的详细信息，不包含敏感的密钥信息

💡 请求示例：

```
const response = await fetch('/api/channel/123', {  
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
    "id": 123,  
    "name": "OpenAI渠道",  
    "type": 1,  
    "status": 1,  
    "priority": 10,  
    "weight": 100,  
    "models": "gpt-3.5-turbo,gpt-4",  
    "group": "default",  
    "base_url": "https://api.openai.com",  
    "model_mapping": "{}",  
    "channel_info": {  
      "is_multi_key": false,  
      "multi_key_mode": "random"  
    }  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "渠道不存在"  
}
```

🧾 字段说明：

- `id` （数字）: 渠道 ID，通过 URL 路径传递
- 返回完整的渠道信息，但不包含密钥字段

### 批量测试渠道连通性

- **接口名称**：批量测试渠道连通性
- **HTTP 方法**：GET
- **路径**：`/api/channel/test`
- **鉴权要求**：管理员
- **功能简介**：批量测试所有或指定渠道的连通性和响应时间

💡 请求示例：

```
const response = await fetch('/api/channel/test?model=gpt-3.5-turbo', {  
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
  "message": "批量测试完成",  
  "data": {  
    "total": 10,  
    "success": 8,  
    "failed": 2,  
    "results": [  
      {  
        "channel_id": 1,  
        "channel_name": "OpenAI渠道",  
        "success": true,  
        "time": 1.25,  
        "message": ""  
      },  
      {  
        "channel_id": 2,  
        "channel_name": "Claude渠道",  
        "success": false,  
        "time": 0,  
        "message": "连接超时"  
      }  
    ]  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "批量测试失败"  
}
```

🧾 字段说明：

- `model` （字符串）: 可选，指定测试模型
- `results` （数组）: 测试结果列表

    - `success` （布尔型）: 测试是否成功
    - `time` （数字）: 响应时间（秒）

### 单个渠道测试

- **接口名称**：单个渠道测试
- **HTTP 方法**：GET
- **路径**：`/api/channel/test/:id`
- **鉴权要求**：管理员
- **功能简介**：测试指定渠道的连通性，支持指定测试模型

💡 请求示例：

```
const response = await fetch('/api/channel/test/123?model=gpt-4', {  
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
  "time": 1.25  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "API密钥无效",  
  "time": 0.5  
}
```

🧾 字段说明：

- `id` （数字）: 渠道 ID，通过 URL 路径传递
- `model` （字符串）: 可选，指定测试的模型名称
- `time` （数字）: 响应时间（秒）

### 批量刷新余额

- **接口名称**：批量刷新余额
- **HTTP 方法**：GET
- **路径**：`/api/channel/update_balance`
- **鉴权要求**：管理员
- **功能简介**：批量更新所有启用渠道的余额信息

💡 请求示例：

```
const response = await fetch('/api/channel/update_balance', {  
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
  "message": "批量更新余额完成"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "批量更新余额失败"  
}
```

🧾 字段说明：

无请求参数，系统会自动更新所有启用渠道的余额

### 单个刷新余额

- **接口名称**：更新指定渠道余额
- **HTTP 方法**：GET
- **路径**：`/api/channel/update_balance/:id`
- **鉴权要求**：管理员
- **功能简介**：更新指定渠道的余额信息，多密钥渠道不支持余额查询

💡 请求示例：

```
const response = await fetch('/api/channel/update_balance/123', {  
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
  "balance": 25.50  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "多密钥渠道不支持余额查询"  
}
```

🧾 字段说明：

- `id` （数字）: 渠道 ID，通过 URL 路径传递
- `balance` （数字）: 更新后的渠道余额

### 新增渠道

- **接口名称**：新增渠道
- **HTTP 方法**：POST
- **路径**：`/api/channel/`
- **鉴权要求**：管理员
- **功能简介**：创建新的 AI 服务渠道，支持单个、批量和多密钥模式

💡 请求示例：

```
const response = await fetch('/api/channel/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    mode: "single",  
    channel: {  
      name: "OpenAI渠道",  
      type: 1,  
      key: "<YOUR_API_KEY>",  
      base_url: "https://api.openai.com",  
      models: ["gpt-3.5-turbo", "gpt-4"],  
      groups: ["default"],  
      priority: 10,  
      weight: 100  
    }  
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
  "message": "不支持的添加模式"  
}
```

🧾 字段说明：

- `mode` （字符串）: 添加模式，可选值："single"、"batch"、"multi_to_single" 
- `multi_key_mode` （字符串）: 多密钥模式，当 mode 为"multi_to_single"时必填
- `channel` （对象）: 渠道配置信息

    - `name` （字符串）: 渠道名称
    - `type` （数字）: 渠道类型
    - `key` （字符串）: API 密钥
    - `base_url` （字符串）: 基础 URL
    - `models` （数组）: 支持的模型列表
    - `groups` （数组）: 可用分组列表
    - `priority` （数字）: 优先级
    - `weight` （数字）: 权重

### 更新渠道

- **接口名称**：更新渠道
- **HTTP 方法**：PUT
- **路径**：`/api/channel/`
- **鉴权要求**：管理员
- **功能简介**：更新现有渠道的配置信息

💡 请求示例：

```
const response = await fetch('/api/channel/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    id: 123,  
    name: "更新的OpenAI渠道",  
    status: 1,  
    priority: 15,  
    weight: 120  
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
  "message": "渠道不存在"  
}
```

🧾 字段说明：

- `id` （数字）: 渠道 ID，必填
- 其他字段与新增渠道接口相同，均为可选

### 删除已禁用渠道

- **接口名称**：删除已禁用渠道
- **HTTP 方法**：DELETE
- **路径**：`/api/channel/disabled`
- **鉴权要求**：管理员
- **功能简介**：批量删除所有已禁用的渠道

💡 请求示例：

```
const response = await fetch('/api/channel/disabled', {  
  method: 'DELETE',  
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
  "data": 5  
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
- `data` （数字）: 删除的渠道数量

### 批量禁用标签渠道

- **接口名称**：批量禁用标签渠道
- **HTTP 方法**：POST
- **路径**：`/api/channel/tag/disabled`
- **鉴权要求**：管理员
- **功能简介**：根据标签批量禁用渠道

💡 请求示例：

```
const response = await fetch('/api/channel/tag/disabled', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    tag: "test-tag"  
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
  "message": "参数错误"  
}
```

🧾 字段说明：

`tag` （字符串）: 要禁用的渠道标签，必填

### 批量启用标签渠道

- **接口名称**：批量启用标签渠道
- **HTTP 方法**：POST
- **路径**：`/api/channel/tag/enabled`
- **鉴权要求**：管理员
- **功能简介**：根据标签批量启用渠道

💡 请求示例：

```
const response = await fetch('/api/channel/tag/enabled', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    tag: "production-tag"  
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
  "message": "参数错误"  
}
```

🧾 字段说明：

`tag` （字符串）: 要启用的渠道标签，必填

### 编辑渠道标签

- **接口名称**：编辑渠道标签
- **HTTP 方法**：PUT
- **路径**：`/api/channel/tag`
- **鉴权要求**：管理员
- **功能简介**：批量编辑指定标签的渠道属性

💡 请求示例：

```
const response = await fetch('/api/channel/tag', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    tag: "old-tag",  
    new_tag: "new-tag",  
    priority: 20,  
    weight: 150,  
    models: "gpt-3.5-turbo,gpt-4,claude-3-sonnet",  
    groups: "default,vip"  
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
  "message": "tag不能为空"  
}
```

🧾 字段说明：

- `tag` （字符串）: 要编辑的标签名称，必填
- `new_tag` （字符串）: 新标签名称，可选
- `priority` （数字）: 新优先级，可选
- `weight` （数字）: 新权重，可选
- `model_mapping` （字符串）: 模型映射配置，可选
- `models` （字符串）: 支持的模型列表，逗号分隔，可选
- `groups` （字符串）: 可用分组列表，逗号分隔，可选

### 删除渠道

- **接口名称**：删除渠道
- **HTTP 方法**：DELETE
- **路径**：`/api/channel/:id`
- **鉴权要求**：管理员
- **功能简介**：硬删除指定渠道，删除后会刷新渠道缓存

💡 请求示例：

```
const response = await fetch('/api/channel/123', {  
  method: 'DELETE',  
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
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "渠道不存在"  
}
```

🧾 字段说明：

`id` （数字）: 渠道 ID，通过 URL 路径传递

### 批量删除渠道

- **接口名称**：批量删除渠道
- **HTTP 方法**：POST
- **路径**：`/api/channel/batch`
- **鉴权要求**：管理员
- **功能简介**：根据 ID 列表列表批量删除渠道

💡 请求示例：

```
const response = await fetch('/api/channel/batch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
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

- `ids` （数组）: 要删除的渠道 ID 列表，必填且不能为空
- `data` （数字）: 成功删除的渠道数量

### 修复渠道能力表

- **接口名称**：修复渠道能力表
- **HTTP 方法**：POST
- **路径**：`/api/channel/fix`
- **鉴权要求**：管理员
- **功能简介**：修复渠道能力表数据，重新构建渠道与模型的映射关系

💡 请求示例：

```
const response = await fetch('/api/channel/fix', {  
  method: 'POST',  
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
    "success": 45,  
    "fails": 2  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "修复能力表失败"  
}
```

🧾 字段说明：

- 无请求参数
- `data.success` （数字）: 成功修复的渠道数量
- `data.fails` （数字）: 修复失败的渠道数量

### 拉取单渠道模型

- **接口名称**：拉取单渠道模型
- **HTTP 方法**：GET
- **路径**：`/api/channel/fetch_models/:id`
- **鉴权要求**：管理员
- **功能简介**：从指定渠道的上游 API 获取可用模型列表

💡 请求示例：

```
const response = await fetch('/api/channel/fetch_models/123', {  
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
    "gpt-3.5-turbo",  
    "gpt-4",  
    "gpt-4-turbo-preview"  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "解析响应失败: invalid character 'H' looking for beginning of value"  
}
```

🧾 字段说明：

- `id` （数字）: 渠道 ID，通过 URL 路径传递
- `data` （数组）: 从上游获取的模型 ID 列表

### 拉取全部渠道模型

- **接口名称**：拉取全部渠道模型
- **HTTP 方法**：POST
- **路径**：`/api/channel/fetch_models`
- **鉴权要求**：管理员
- **功能简介**：通过提供的配置信息从上游 API获取 API 获取模型列表，用于新建渠道时预览

💡 请求示例：

```
const response = await fetch('/api/channel/fetch_models', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    base_url: "https://api.openai.com",  
    type: 1,  
    key: "<YOUR_API_KEY>"  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "data": [  
    "gpt-3.5-turbo",  
    "gpt-4",  
    "text-davinci-003"  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "Failed to fetch models"  
}
```

🧾 字段说明：

- `base_url` （字符串）: 基础 URL，可选，为空时使用默认 URL
- `type` （数字）: 渠道类型，必填
- `key` （字符串）: API 密钥，必填
- `data` （数组）: 获取到的模型列表

### 批量设置渠道标签

- **接口名称**：批量设置渠道标签
- **HTTP 方法**：POST
- **路径**：`/api/channel/batch/tag`
- **鉴权要求**：管理员
- **功能简介**：为指定的渠道列表批量设置标签

💡 请求示例：

```
const response = await fetch('/api/channel/batch/tag', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    ids: [1, 2, 3],  
    tag: "production"  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "",  
  "data": 3  
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

- `ids` （数组）: 要设置标签的渠道 ID 列表，必填且不能为空
- `tag` （字符串）: 要设置的标签名称，传 null 可清除标签
- `data` （数字）: 成功设置标签的渠道数量

### 根据标签获取模型

- **接口名称**：根据标签获取模型
- **HTTP 方法**：GET
- **路径**：`/api/channel/tag/models`
- **鉴权要求**：管理员
- **功能简介**：获取指定标签下所有渠道中模型数量最多的模型列表

💡 请求示例：

```
const response = await fetch('/api/channel/tag/models?tag=production', {  
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
  "data": "gpt-3.5-turbo,gpt-4,claude-3-sonnet"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "tag不能为空"  
}
```

🧾 字段说明：

- `tag` （字符串）: 标签名称，必填
- `data` （字符串）: 该标签下模型最多的渠道的模型列表，逗号分隔

### 复制渠道

- **接口名称**：复制渠道
- **HTTP 方法**：POST
- **路径**：`/api/channel/copy/:id`
- **鉴权要求**：管理员
- **功能简介**：复制现有渠道创建新渠道，支持自定义后缀和余额重置选项

💡 请求示例：

```
const response = await fetch('/api/channel/copy/123?suffix=_备份&reset_balance=true', {  
  method: 'POST',  
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
    "id": 124  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "invalid id"  
}
```

🧾 字段说明：

- `id` （数字）: 要复制的渠道 ID，通过 URL 路径传递
- `suffix` （字符串）: 可选，添加到原名称后的后缀，默认为"_复制"
- `reset_balance` （布尔型）: 可选，是否重置余额和已用配额为 0，默认为 true
- `data.id` （数字）: 新创建的渠道 ID
