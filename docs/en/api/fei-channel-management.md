## 核心概念 (Core Concepts)

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API访问凭证，也指模型处理的文本单元 | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# Channel Management Module

!!! info "Function Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A complete management system for AI service provider channels. Supports channel creation, deletion, modification, querying, batch operations, connectivity testing, balance inquiry, and tag management. Includes advanced features like model capability synchronization and channel duplication.

## 🔐 Administrator Authentication

### Get Channel List

- **Interface Name**: Get Channel List
- **HTTP Method**: GET
- **Path**: `/api/channel/`
- **Authentication Requirement**: Administrator
- **Function Description**: Paginated retrieval of the list information for all channels in the system, supporting filtering by type, status, and tag mode

💡 Request Example:

```
const response = await fetch('/api/channel/?p=1&page_size=20&id_sort=false&tag_mode=false&type=1&status=enabled', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve channel list"  
}
```

🧾 Field Description:

- `p` (Number): Page number, default is 1
- `page_size` (Number): Quantity per page, default is 20
- `id_sort` (Boolean): Whether to sort by ID, defaults to sorting by priority
- `tag_mode` (Boolean): Whether to enable tag mode
- `type` (Number): Channel type filter
- `status` (String): Status filter, optional values: "enabled", "disabled", "all"

### Search Channels

- **Interface Name**: Search Channels
- **HTTP Method**: GET
- **Path**: `/api/channel/search`
- **Authentication Requirement**: Administrator
- **Function Description**: Search channels based on keywords, groups, models, and other conditions

💡 Request Example:

```
const response = await fetch('/api/channel/search?keyword=openai&group=default&model=gpt-4&id_sort=false&tag_mode=false&p=1&page_size=20&type=1&status=enabled', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{    "success": false,    "message": "Failed to search channels"  }
```

🧾 Field Description:

- `keyword` (String): Search keyword, can match channel name
- `group` (String): Group filtering condition
- `model` (String): Model filtering condition
- Other parameters are the same as the Get Channel List interface.

### Query Channel Model Capabilities

- **Interface Name**: Query Channel Model Capabilities
- **HTTP Method**: GET
- **Path**: `/api/channel/models`
- **Authentication Requirement**: Administrator
- **Function Description**: Retrieve the list of models supported by all channels in the system

💡 Request Example:

```
const response = await fetch('/api/channel/models', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve model list"  
}
```

🧾 Field Description:

`data` (Array): Model information list

- `id` (String): Model ID
- `name` (String): Model display name

### Query Enabled Model Capabilities

- **Interface Name**: Query Enabled Model Capabilities
- **HTTP Method**: GET
- **Path**: `/api/channel/models_enabled`
- **Authentication Requirement**: Administrator
- **Function Description**: Retrieve the list of models supported by currently enabled channels

💡 Request Example:

```
const response = await fetch('/api/channel/models_enabled', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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
    "gpt-3.5-turbo",  
    "gpt-4",  
    "claude-3-sonnet"  
  ]  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to retrieve enabled models"  
}
```

🧾 Field Description:

`data` (Array): List of enabled model IDs

### Get Single Channel

- **Interface Name**: Get Single Channel
- **HTTP Method**: GET
- **Path**: `/api/channel/:id`
- **Authentication Requirement**: Administrator
- **Function Description**: Retrieve detailed information for a specified channel, excluding sensitive key information

💡 Request Example:

```
const response = await fetch('/api/channel/123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Channel does not exist"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, passed via URL path
- Returns complete channel information, but excludes key fields.

### Batch Test Channel Connectivity

- **Interface Name**: Batch Test Channel Connectivity
- **HTTP Method**: GET
- **Path**: `/api/channel/test`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch test the connectivity and response time of all or specified channels

💡 Request Example:

```
const response = await fetch('/api/channel/test?model=gpt-3.5-turbo', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "Batch test completed",  
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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Batch test failed"  
}
```

🧾 Field Description:

- `model` (String): Optional, specifies the test model
- `results` (Array): Test results list

    - `success` (Boolean): Whether the test was successful
    - `time` (Number): Response time (seconds)

### Single Channel Test

- **Interface Name**: Single Channel Test
- **HTTP Method**: GET
- **Path**: `/api/channel/test/:id`
- **Authentication Requirement**: Administrator
- **Function Description**: Test the connectivity of a specified channel, supporting the specification of a test model

💡 Request Example:

```
const response = await fetch('/api/channel/test/123?model=gpt-4', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "time": 1.25  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "API key is invalid",  
  "time": 0.5  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, passed via URL path
- `model` (String): Optional, specifies the name of the test model
- `time` (Number): Response time (seconds)

### Batch Refresh Balance

- **Interface Name**: Batch Refresh Balance
- **HTTP Method**: GET
- **Path**: `/api/channel/update_balance`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch update balance information for all enabled channels

💡 Request Example:

```
const response = await fetch('/api/channel/update_balance', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "Batch balance update completed"  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Batch balance update failed"  
}
```

🧾 Field Description:

No request parameters, the system automatically updates the balance of all enabled channels.

### Single Balance Refresh

- **Interface Name**: Update Specified Channel Balance
- **HTTP Method**: GET
- **Path**: `/api/channel/update_balance/:id`
- **Authentication Requirement**: Administrator
- **Function Description**: Update the balance information for a specified channel. Multi-key channels do not support balance inquiry.

💡 Request Example:

```
const response = await fetch('/api/channel/update_balance/123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "balance": 25.50  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Multi-key channels do not support balance inquiry"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, passed via URL path
- `balance` (Number): Updated channel balance

### Add Channel

- **Interface Name**: Add Channel
- **HTTP Method**: POST
- **Path**: `/api/channel/`
- **Authentication Requirement**: Administrator
- **Function Description**: Create a new AI service channel, supporting single, batch, and multi-key modes

💡 Request Example:

```
const response = await fetch('/api/channel/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Unsupported addition mode"  
}
```

🧾 Field Description:

- `mode` (String): Addition mode, optional values: "single", "batch", "multi_to_single"
- `multi_key_mode` (String): Multi-key mode, required when mode is "multi_to_single"
- `channel` (Object): Channel configuration information

    - `name` (String): Channel name
    - `type` (Number): Channel type
    - `key` (String): API key
    - `base_url` (String): Base URL
    - `models` (Array): List of supported models
    - `groups` (Array): List of available groups
    - `priority` (Number): Priority
    - `weight` (Number): Weight

### Update Channel

- **Interface Name**: Update Channel
- **HTTP Method**: PUT
- **Path**: `/api/channel/`
- **Authentication Requirement**: Administrator
- **Function Description**: Update the configuration information of an existing channel

💡 Request Example:

```
const response = await fetch('/api/channel/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Channel does not exist"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, required
- Other fields are the same as the Add Channel interface, and are all optional.

### Delete Disabled Channels

- **Interface Name**: Delete Disabled Channels
- **HTTP Method**: DELETE
- **Path**: `/api/channel/disabled`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch delete all disabled channels

💡 Request Example:

```
const response = await fetch('/api/channel/disabled', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": 5  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Deletion failed"  
}
```

🧾 Field Description:

- No request parameters
- `data` (Number): Number of channels deleted

### Batch Disable Tagged Channels

- **Interface Name**: Batch Disable Tagged Channels
- **HTTP Method**: POST
- **Path**: `/api/channel/tag/disabled`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch disable channels based on tags

💡 Request Example:

```
const response = await fetch('/api/channel/tag/disabled', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    tag: "test-tag"  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Parameter error"  
}
```

🧾 Field Description:

`tag` (String): The channel tag to be disabled, required

### Batch Enable Tagged Channels

- **Interface Name**: Batch Enable Tagged Channels
- **HTTP Method**: POST
- **Path**: `/api/channel/tag/enabled`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch enable channels based on tags

💡 Request Example:

```
const response = await fetch('/api/channel/tag/enabled', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    tag: "production-tag"  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Parameter error"  
}
```

🧾 Field Description:

`tag` (String): The channel tag to be enabled, required

### Edit Channel Tags

- **Interface Name**: Edit Channel Tags
- **HTTP Method**: PUT
- **Path**: `/api/channel/tag`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch edit channel attributes for specified tags

💡 Request Example:

```
const response = await fetch('/api/channel/tag', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Tag cannot be empty"  
}
```

🧾 Field Description:

- `tag` (String): The tag name to be edited, required
- `new_tag` (String): New tag name, optional
- `priority` (Number): New priority, optional
- `weight` (Number): New weight, optional
- `model_mapping` (String): Model mapping configuration, optional
- `models` (String): List of supported models, comma-separated, optional
- `groups` (String): List of available groups, comma-separated, optional

### Delete Channel

- **Interface Name**: Delete Channel
- **HTTP Method**: DELETE
- **Path**: `/api/channel/:id`
- **Authentication Requirement**: Administrator
- **Function Description**: Hard delete the specified channel. Channel cache will be refreshed after deletion.

💡 Request Example:

```
const response = await fetch('/api/channel/123', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Channel does not exist"  
}
```

🧾 Field Description:

`id` (Number): Channel ID, passed via URL path

### Batch Delete Channels

- **Interface Name**: Batch Delete Channels
- **HTTP Method**: POST
- **Path**: `/api/channel/batch`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch delete channels based on a list of IDs

💡 Request Example:

```
const response = await fetch('/api/channel/batch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    ids: [1, 2, 3, 4, 5]  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": 5  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Parameter error"  
}
```

🧾 Field Description:

- `ids` (Array): List of channel IDs to be deleted, required and cannot be empty
- `data` (Number): Number of channels successfully deleted

### Fix Channel Capability Table

- **Interface Name**: Fix Channel Capability Table
- **HTTP Method**: POST
- **Path**: `/api/channel/fix`
- **Authentication Requirement**: Administrator
- **Function Description**: Fix channel capability table data, rebuilding the mapping relationship between channels and models

💡 Request Example:

```
const response = await fetch('/api/channel/fix', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to fix capability table"  
}
```

🧾 Field Description:

- No request parameters
- `data.success` (Number): Number of channels successfully fixed
- `data.fails` (Number): Number of channels that failed to be fixed

### Fetch Single Channel Models

- **Interface Name**: Fetch Single Channel Models
- **HTTP Method**: GET
- **Path**: `/api/channel/fetch_models/:id`
- **Authentication Requirement**: Administrator
- **Function Description**: Retrieve the list of available models from the upstream API of the specified channel

💡 Request Example:

```
const response = await fetch('/api/channel/fetch_models/123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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
    "gpt-3.5-turbo",  
    "gpt-4",  
    "gpt-4-turbo-preview"  
  ]  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to parse response: invalid character 'H' looking for beginning of value"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, passed via URL path
- `data` (Array): List of model IDs retrieved from upstream

### Fetch All Channel Models

- **Interface Name**: Fetch All Channel Models
- **HTTP Method**: POST
- **Path**: `/api/channel/fetch_models`
- **Authentication Requirement**: Administrator
- **Function Description**: Retrieve the list of models from the upstream API using the provided configuration information, used for previewing when creating a new channel

💡 Request Example:

```
const response = await fetch('/api/channel/fetch_models', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    base_url: "https://api.openai.com",  
    type: 1,  
    key: "<YOUR_API_KEY>"  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Failed to fetch models"  
}
```

🧾 Field Description:

- `base_url` (String): Base URL, optional, uses default URL if empty
- `type` (Number): Channel type, required
- `key` (String): API key, required
- `data` (Array): List of models retrieved

### Batch Set Channel Tags

- **Interface Name**: Batch Set Channel Tags
- **HTTP Method**: POST
- **Path**: `/api/channel/batch/tag`
- **Authentication Requirement**: Administrator
- **Function Description**: Batch set tags for a specified list of channels

💡 Request Example:

```
const response = await fetch('/api/channel/batch/tag', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    ids: [1, 2, 3],  
    tag: "production"  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": 3  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Parameter error"  
}
```

🧾 Field Description:

- `ids` (Array): List of channel IDs to set tags for, required and cannot be empty
- `tag` (String): The tag name to be set. Passing null clears the tag.
- `data` (Number): Number of channels successfully tagged

### Get Models by Tag

- **Interface Name**: Get Models by Tag
- **HTTP Method**: GET
- **Path**: `/api/channel/tag/models`
- **Authentication Requirement**: Administrator
- **Function Description**: Retrieve the list of models with the highest model count among all channels under the specified tag

💡 Request Example:

```
const response = await fetch('/api/channel/tag/models?tag=production', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": "gpt-3.5-turbo,gpt-4,claude-3-sonnet"  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "Tag cannot be empty"  
}
```

🧾 Field Description:

- `tag` (String): Tag name, required
- `data` (String): Model list of the channel with the most models under this tag, comma-separated

### Duplicate Channel

- **Interface Name**: Duplicate Channel
- **HTTP Method**: POST
- **Path**: `/api/channel/copy/:id`
- **Authentication Requirement**: Administrator
- **Function Description**: Duplicate an existing channel to create a new one, supporting custom suffixes and balance reset options

💡 Request Example:

```
const response = await fetch('/api/channel/copy/123?suffix=_备份&reset_balance=true', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "id": 124  
  }  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "invalid id"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID to be duplicated, passed via URL path
- `suffix` (String): Optional, suffix added to the original name, defaults to "_复制"
- `reset_balance` (Boolean): Optional, whether to reset the balance and used quota to 0, defaults to true
- `data.id` (Number): ID of the newly created channel