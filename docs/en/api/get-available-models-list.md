## 核心概念 (Core Concepts)

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API访问凭证，也指模型处理的文本单元 | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# Get Available Model List (Model)

!!! info "Note"
    The API prefix is uniformly http(s)://`<your-domain>`

    Production environments should use HTTPS to secure authentication tokens. HTTP is only recommended for development environments.

- **Interface Name**: Get the list of available models for the frontend
- **HTTP Method**: GET
- **Path**: `/api/models`
- **Authentication Requirement**: User
- **Function Description**: Retrieves the list of AI models accessible to the current user, used for frontend Dashboard display

 💡 Request Example:

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

 ✅ Successful Response Example:

```
{  
  "success": true,  
  "data": {  
    "1": ["gpt-3.5-turbo", "gpt-4"],  
    "2": ["claude-3-sonnet", "claude-3-haiku"]  
  }  
}
```

 ❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "未授权访问"  
}
```

 🧾 Field Description:

- `data` (Object): Mapping from Channel ID to the model list
    - Key (String): Channel ID
    - Value (Array): List of model names supported by this channel