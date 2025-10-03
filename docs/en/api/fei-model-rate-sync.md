## Core Concepts

| Chinese | English | Description | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API访问凭证，也指模型处理的文本单元 | API access credentials, or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# Model Ratio Synchronization Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    An advanced feature specifically designed for model pricing synchronization. It supports concurrently fetching ratio configurations from multiple upstream sources, automatically identifies different interface formats, and provides data confidence assessment. Primarily used for bulk updating model pricing information.

## 🔐 Root Authentication

### Get List of Synchronizable Channels

- **Interface Name**: Get List of Synchronizable Channels
- **HTTP Method**: GET
- **Path**: `/api/ratio_sync/channels`
- **Authentication Requirement**: Root
- **Feature Summary**: Retrieves a list of all channels available for ratio synchronization in the system, including channels with valid BaseURLs and official presets.

💡 Request Example:

```
const response = await fetch('/api/ratio_sync/channels', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    {  
      "id": 1,  
      "name": "OpenAI官方",  
      "base_url": "https://api.openai.com",  
      "status": 1  
    },  
    {  
      "id": 2,  
      "name": "Claude API",  
      "base_url": "https://api.anthropic.com",  
      "status": 1  
    },  
    {  
      "id": -100,  
      "name": "官方倍率预设",  
      "base_url": "https://basellm.github.io",  
      "status": 1  
    }  
  ]  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取渠道列表失败"  
}
```

🧾 Field Description:

- `data` (array): List of synchronizable channels
    - `id` (number): Channel ID, -100 is the official preset
    - `name` (string): Channel name
    - `base_url` (string): Channel base URL
    - `status` (number): Channel status, 1=Enabled

### Fetch Ratios from Upstream

- **Interface Name**: Fetch Ratios from Upstream
- **HTTP Method**: POST
- **Path**: `/api/ratio_sync/fetch`
- **Authentication Requirement**: Root
- **Feature Summary**: Fetches model ratio configurations from specified upstream channels or custom URLs. Supports concurrent fetching and differential comparison.

💡 Request Example (via Channel ID):

```
const response = await fetch('/api/ratio_sync/fetch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
  },  
  body: JSON.stringify({  
    channel_ids: [1, 2, -100],  
    timeout: 10  
  })  
});  
const data = await response.json();
```

💡 Request Example (via Custom URL):

```
const response = await fetch('/api/ratio_sync/fetch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
  },  
  body: JSON.stringify({  
    upstreams: [  
      {  
        name: "自定义源",  
        base_url: "https://example.com",  
        endpoint: "/api/ratio_config"  
      }  
    ],  
    timeout: 15  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "data": {  
    "differences": {  
      "gpt-4": {  
        "model_ratio": {  
          "current": 15.0,  
          "upstreams": {  
            "OpenAI官方(1)": 20.0,  
            "官方倍率预设(-100)": "same"  
          },  
          "confidence": {  
            "OpenAI官方(1)": true,  
            "官方倍率预设(-100)": true  
          }  
        }  
      },  
      "claude-3-sonnet": {  
        "model_price": {  
          "current": null,  
          "upstreams": {  
            "Claude API(2)": 0.003  
          },  
          "confidence": {  
            "Claude API(2)": true  
          }  
        }  
      }  
    },  
    "test_results": [  
      {  
        "name": "OpenAI官方(1)",  
        "status": "success"  
      },  
      {  
        "name": "Claude API(2)",  
        "status": "error",  
        "error": "连接超时"  
      }
    ]  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "无有效上游渠道"  
}
```

🧾 Field Description:

- `channel_ids` (array): List of channel IDs to synchronize, optional
- `upstreams` (array): List of custom upstream configurations, optional
    - `name` (string): Upstream name
    - `base_url` (string): Base URL, must start with http
    - `endpoint` (string): Interface endpoint, defaults to "/api/ratio_config"
- `timeout` (number): Request timeout time (seconds), defaults to 10 seconds
- `differences` (object): Differential ratio comparison results
    - Key is the model name, value contains difference information for each ratio type
    - `current`: Current local value
    - `upstreams`: Values from each upstream, "same" means identical to local
    - `confidence`: Data confidence, false indicates potentially unreliable
- `test_results` (array): Test results for each upstream