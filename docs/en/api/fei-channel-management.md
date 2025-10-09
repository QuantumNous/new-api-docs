# Channel Management Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    A complete management system for AI service provider channels. Supports CRUD operations for channels, batch operations, connectivity testing, balance inquiry, tag management, and other features. Includes advanced features like model capability synchronization and channel duplication.

## 🔐 Administrator Authentication

### Get Channel List

- **API Name**: Get Channel List
- **HTTP Method**: GET
- **Path**: `/api/channel/`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Paginates and retrieves the list information of all channels in the system, supporting filtering by type, status, and tag mode.

💡 Request Example:

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
  "message": "获取渠道列表失败"  
}
```

🧾 Field Description:

- `p` (Number): Page number, default is 1
- `page_size` (Number): Items per page, default is 20
- `id_sort` (Boolean): Whether to sort by ID, default is sorting by priority
- `tag_mode` (Boolean): Whether to enable tag mode
- `type` (Number): Channel type filter
- `status` (String): Status filter, optional values: "enabled", "disabled", "all"

### Search Channels

- **API Name**: Search Channels
- **HTTP Method**: GET
- **Path**: `/api/channel/search`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Search channels based on keywords, groups, models, and other criteria.

💡 Request Example:

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
{    "success": false,    "message": "搜索渠道失败"  }
```

🧾 Field Description:

- `keyword` (String): Search keyword, can match channel name
- `group` (String): Group filter condition
- `model` (String): Model filter condition
- Other parameters are the same as the Get Channel List API.

### Query Channel Model Capabilities

- **API Name**: Query Channel Model Capabilities
- **HTTP Method**: GET
- **Path**: `/api/channel/models`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Retrieve the list of models supported by all channels in the system.

💡 Request Example:

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
  "message": "获取模型列表失败"  
}
```

🧾 Field Description:

`data` (Array): Model information list

- `id` (String): Model ID
- `name` (String): Model display name

### Query Enabled Model Capabilities

- **API Name**: Query Enabled Model Capabilities
- **HTTP Method**: GET
- **Path**: `/api/channel/models_enabled`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Retrieve the list of models supported by currently enabled channels.

💡 Request Example:

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
  "message": "获取启用模型失败"  
}
```

🧾 Field Description:

`data` (Array): List of enabled model IDs

### Get Single Channel

- **API Name**: Get Single Channel
- **HTTP Method**: GET
- **Path**: `/api/channel/:id`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Retrieve detailed information for the specified channel, excluding sensitive key information.

💡 Request Example:

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
  "message": "渠道不存在"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, passed via URL path
- Returns complete channel information, but excludes key fields.

### Batch Test Channel Connectivity

- **API Name**: Batch Test Channel Connectivity
- **HTTP Method**: GET
- **Path**: `/api/channel/test`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Batch test the connectivity and response time of all or specified channels.

💡 Request Example:

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

✅ Successful Response Example:

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

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "批量测试失败"  
}
```

🧾 Field Description:

- `model` (String): Optional, specify the test model
- `results` (Array): List of test results
    - `success` (Boolean): Whether the test was successful
    - `time` (Number): Response time (seconds)

### Single Channel Test

- **API Name**: Single Channel Test
- **HTTP Method**: GET
- **Path**: `/api/channel/test/:id`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Test the connectivity of the specified channel, supporting a specified test model.

💡 Request Example:

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
  "message": "API密钥无效",  
  "time": 0.5  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, passed via URL path
- `model` (String): Optional, specify the name of the test model
- `time` (Number): Response time (seconds)

### Batch Refresh Balance

- **API Name**: Batch Refresh Balance
- **HTTP Method**: GET
- **Path**: `/api/channel/update_balance`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Batch update the balance information of all enabled channels.

💡 Request Example:

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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "批量更新余额完成"  
}
```

❗ Failed Response Example:

```
{  
  "success": false,  
  "message": "批量更新余额失败"  
}
```

🧾 Field Description:

No request parameters. The system automatically updates the balance of all enabled channels.

### Single Refresh Balance

- **API Name**: Update specified channel balance
- **HTTP Method**: GET
- **Path**: `/api/channel/update_balance/:id`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Update the balance information of the specified channel. Multi-key channels do not support balance inquiry.

💡 Request Example:

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
  "message": "多密钥渠道不支持余额查询"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, passed via URL path
- `balance` (Number): Updated channel balance

### Add Channel

- **API Name**: Add Channel
- **HTTP Method**: POST
- **Path**: `/api/channel/`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Create a new AI service channel, supporting single, batch, and multi-key modes.

💡 Request Example:

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
  "message": "不支持的添加模式"  
}
```

🧾 Field Description:

- `mode` (String): Addition mode, optional values: "single", "batch", "multi_to_single"
- `multi_key_mode` (String): Multi-key mode, required when mode is "multi_to_single"
- `channel` (Object): Channel configuration information
    - `name` (String): Channel name
    - `type` (Number): Channel type
    - `key` (String): API Key
    - `base_url` (String): Base URL
    - `models` (Array): List of supported models
    - `groups` (Array): List of available groups
    - `priority` (Number): Priority
    - `weight` (Number): Weight

### Update Channel

- **API Name**: Update Channel
- **HTTP Method**: PUT
- **Path**: `/api/channel/`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Update the configuration information of an existing channel.

💡 Request Example:

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
  "message": "渠道不存在"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, required
- Other fields are the same as the Add Channel API, all are optional.

### Delete Disabled Channels

- **API Name**: Delete Disabled Channels
- **HTTP Method**: DELETE
- **Path**: `/api/channel/disabled`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Batch delete all disabled channels.

💡 Request Example:

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
  "message": "删除失败"  
}
```

🧾 Field Description:

- No request parameters
- `data` (Number): Number of channels deleted

### Batch Disable Tagged Channels

- **API Name**: Batch Disable Tagged Channels
- **HTTP Method**: POST
- **Path**: `/api/channel/tag/disabled`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Batch disable channels based on tags.

💡 Request Example:

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
  "message": "参数错误"  
}
```

🧾 Field Description:

`tag` (String): Channel tag to be disabled, required

### Batch Enable Tagged Channels

- **API Name**: Batch Enable Tagged Channels
- **HTTP Method**: POST
- **Path**: `/api/channel/tag/enabled`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Batch enable channels based on tags.

💡 Request Example:

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
  "message": "参数错误"  
}
```

🧾 Field Description:

`tag` (String): Channel tag to be enabled, required

### Edit Channel Tags

- **API Name**: Edit Channel Tags
- **HTTP Method**: PUT
- **Path**: `/api/channel/tag`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Batch edit channel attributes for specified tags.

💡 Request Example:

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
  "message": "tag不能为空"  
}
```

🧾 Field Description:

- `tag` (String): Tag name to be edited, required
- `new_tag` (String): New tag name, optional
- `priority` (Number): New priority, optional
- `weight` (Number): New weight, optional
- `model_mapping` (String): Model mapping configuration, optional
- `models` (String): List of supported models, comma-separated, optional
- `groups` (String): List of available groups, comma-separated, optional

### Delete Channel

- **API Name**: Delete Channel
- **HTTP Method**: DELETE
- **Path**: `/api/channel/:id`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Hard delete the specified channel; channel cache will be refreshed after deletion.

💡 Request Example:

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
  "message": "渠道不存在"  
}
```

🧾 Field Description:

`id` (Number): Channel ID, passed via URL path

### Batch Delete Channels

- **API Name**: Batch Delete Channels
- **HTTP Method**: POST
- **Path**: `/api/channel/batch`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Batch delete channels based on a list of IDs.

💡 Request Example:

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
  "message": "参数错误"  
}
```

🧾 Field Description:

- `ids` (Array): List of channel IDs to be deleted, required and cannot be empty
- `data` (Number): Number of channels successfully deleted

### Fix Channel Capability Table

- **API Name**: Fix Channel Capability Table
- **HTTP Method**: POST
- **Path**: `/api/channel/fix`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Fix channel capability table data, rebuilding the mapping relationship between channels and models.

💡 Request Example:

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
  "message": "修复能力表失败"  
}
```

🧾 Field Description:

- No request parameters
- `data.success` (Number): Number of channels successfully fixed
- `data.fails` (Number): Number of channels that failed to be fixed

### Fetch Single Channel Models

- **API Name**: Fetch Single Channel Models
- **HTTP Method**: GET
- **Path**: `/api/channel/fetch_models/:id`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Fetch the list of available models from the upstream API of the specified channel.

💡 Request Example:

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
  "message": "解析响应失败: invalid character 'H' looking for beginning of value"  
}
```

🧾 Field Description:

- `id` (Number): Channel ID, passed via URL path
- `data` (Array): List of model IDs fetched from upstream

### Fetch All Channel Models

- **API Name**: Fetch All Channel Models
- **HTTP Method**: POST
- **Path**: `/api/channel/fetch_models`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Fetch the list of models from the upstream API using the provided configuration information, used for preview when creating a new channel.

💡 Request Example:

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
- `key` (String): API Key, required
- `data` (Array): List of fetched models

### Batch Set Channel Tags

- **API Name**: Batch Set Channel Tags
- **HTTP Method**: POST
- **Path**: `/api/channel/batch/tag`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Batch set tags for the specified list of channels.

💡 Request Example:

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
  "message": "参数错误"  
}
```

🧾 Field Description:

- `ids` (Array): List of channel IDs to set tags for, required and cannot be empty
- `tag` (String): Tag name to be set. Passing null clears the tag.
- `data` (Number): Number of channels successfully tagged

### Get Models by Tag

- **API Name**: Get Models by Tag
- **HTTP Method**: GET
- **Path**: `/api/channel/tag/models`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Retrieve the list of models that are most numerous among all channels under the specified tag.

💡 Request Example:

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
  "message": "tag不能为空"  
}
```

🧾 Field Description:

- `tag` (String): Tag name, required
- `data` (String): List of models from the channel with the most models under this tag, comma-separated.

### Duplicate Channel

- **API Name**: Duplicate Channel
- **HTTP Method**: POST
- **Path**: `/api/channel/copy/:id`
- **Authentication Requirement**: Administrator
- **Feature Summary**: Duplicate an existing channel to create a new one, supporting custom suffixes and balance reset options.

💡 Request Example:

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
- `suffix` (String): Optional, suffix added after the original name, default is "_复制"
- `reset_balance` (Boolean): Optional, whether to reset balance and used quota to 0, default is true
- `data.id` (Number): ID of the newly created channel