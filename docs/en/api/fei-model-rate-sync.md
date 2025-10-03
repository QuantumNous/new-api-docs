# Model Ratio Synchronization Module

!!! info "Feature Description"
    The interface prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    An advanced feature specifically designed for model pricing synchronization. It supports concurrently fetching ratio configurations from multiple upstream sources, automatically recognizes different interface formats, and provides data credibility assessment. It is primarily used for bulk updating model pricing information.

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
      "name": "OpenAI Official",  
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
      "name": "Official Ratio Preset",  
      "base_url": "https://basellm.github.io",  
      "status": 1  
    }  
  ]  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve channel list"  
}
```

🧾 Field Description:

- `data` (Array): List of synchronizable channels
    - `id` (Number): Channel ID, -100 is the official preset
    - `name` (String): Channel Name
    - `base_url` (String): Channel Base URL
    - `status` (Number): Channel Status, 1=Enabled

### Fetch Ratios from Upstream

- **Interface Name**: Fetch Ratios from Upstream
- **HTTP Method**: POST
- **Path**: `/api/ratio_sync/fetch`
- **Authentication Requirement**: Root
- **Feature Summary**: Fetches model ratio configurations from specified upstream channels or custom URLs, supporting concurrent retrieval and differential comparison.

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
        name: "Custom Source",  
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
            "OpenAI Official(1)": 20.0,  
            "Official Ratio Preset(-100)": "same"  
          },  
          "confidence": {  
            "OpenAI Official(1)": true,  
            "Official Ratio Preset(-100)": true  
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
        "name": "OpenAI Official(1)",  
        "status": "success"  
      },  
      {  
        "name": "Claude API(2)",  
        "status": "error",  
        "error": "Connection Timeout"  
      }
    ]  
  }  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "No valid upstream channels"  
}
```

🧾 Field Description:

- `channel_ids` (Array): List of channel IDs to synchronize, optional
- `upstreams` (Array): List of custom upstream configurations, optional
    - `name` (String): Upstream Name
    - `base_url` (String): Base URL, must start with http
    - `endpoint` (String): Interface endpoint, defaults to "/api/ratio_config"
- `timeout` (Number): Request timeout duration (seconds), defaults to 10 seconds
- `differences` (Object): Differential ratio comparison results
    - Key is the model name, value contains difference information for various ratio types
    - `current`: Current local value
    - `upstreams`: Values from each upstream; "same" indicates it matches the local value
    - `confidence`: Data credibility; false indicates it may be unreliable
- `test_results` (Array): Test results for each upstream