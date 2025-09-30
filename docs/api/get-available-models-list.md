# 获取可用模型列表（Model）

!!! info "说明"
    接口前缀统一为 http(s)://`<your-domain>`

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
    'Authorization': 'Bearer your_user_token'  
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

- `data` （对象）: 渠道 ID 到模型列表的映射
    - 键 （字符串）: 渠道 ID
    - 值 （数组）: 该渠道支持的模型名称列表

