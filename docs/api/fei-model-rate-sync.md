# 模型倍率同步模块

!!! info "功能说明"
    接口前缀统一为 https://`<your-domain>`

    专门用于模型定价同步的高级功能 。支持从多个上游源并发获取倍率配置，自动识别不同接口格式，提供数据可信度评估。主要用于批量更新模型定价信息。

## 🔐 Root鉴权


### 获取可同步渠道列表

- **接口名称**：获取可同步渠道列表
- **HTTP 方法**：GET
- **路径**：`/api/ratio_sync/channels`
- **鉴权要求**：Root
- **功能简介**：获取系统中所有可用于倍率同步的渠道列表，包括有效 BaseURL 的渠道和官方预设

💡 请求示例：

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

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取渠道列表失败"  
}
```

🧾 字段说明：

- `data` （数组）: 可同步渠道列表 
    - `id` （数字）: 渠道 ID，-100 为官方预设
    - `name` （字符串）: 渠道名称
    - `base_url` （字符串）: 渠道基础 URL
    - `status` （数字）: 渠道状态，1=启用

### 从上游拉取倍率

- **接口名称**：从上游拉取倍率
- **HTTP 方法**：POST
- **路径**：`/api/ratio_sync/fetch`
- **鉴权要求**：Root
- **功能简介**：从指定的上游渠道或自定义 URL 拉取模型倍率配置，支持并发获取和差异化对比

💡 请求示例（通过渠道 ID）：

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

💡 请求示例（通过自定义 URL）：

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

✅ 成功响应示例：

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

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "无有效上游渠道"  
}
```

🧾 字段说明：

- `channel_ids` （数组）: 要同步的渠道 ID 列表，可选 
- `upstreams` （数组）: 自定义上游配置列表，可选 

    - `name` （字符串）: 上游名称
    - `base_url` （字符串）: 基础 URL，必须以 http 开头
    - `endpoint` （字符串）: 接口端点，默认为"/api/ratio_config"
- `timeout` （数字）: 请求超时时间（秒），默认为 10 秒 
- `differences` （对象）: 差异化倍率对比结果 

    - 键为模型名称，值包含各倍率类型的差异信息
    - `current`： 本地当前值
    - `upstreams`： 各上游的值，"same"表示与本地相同
    - `confidence`： 数据可信度，false 表示可能不可信 
- `test_results` （数组）: 各上游的测试结果 
