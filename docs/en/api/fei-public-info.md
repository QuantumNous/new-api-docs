# Public Information Module

!!! info "Function Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    Provides system information that does not require authentication or requires low-level access, including model lists, pricing information, announcement content, etc. Supports multi-language display and dynamic configuration. The frontend homepage and model marketplace primarily rely on these interfaces to fetch display data.

## 🔐 No Authentication Required

### Get Announcement Content

- **Interface Name**: Get Announcement Content
- **HTTP Method**: GET
- **Path**: `/api/notice`
- **Authentication Requirement**: Public
- **Function Summary**: Retrieves system announcement content, supporting Markdown format

💡 Request Example:

```
const response = await fetch('/api/notice', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": "# 系统公告\n\n欢迎使用New API系统！"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取公告失败"  
}
```

🧾 Field Description:

`data` (String): Announcement content, supporting Markdown format

### About Page Information

- **Interface Name**: About Page Information
- **HTTP Method**: GET
- **Path**: `/api/about`
- **Authentication Requirement**: Public
- **Function Summary**: Retrieves custom content for the About page

💡 Request Example:

```
const response = await fetch('/api/about', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": "# 关于我们\n\nNew API是一个强大的AI网关系统..."  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取关于信息失败"  
}
```

🧾 Field Description:

`data` (String): About page content, supporting Markdown format or URL link

### Homepage Custom Content

- **Interface Name**: Homepage Custom Content
- **HTTP Method**: GET
- **Path**: `/api/home_page_content`
- **Authentication Requirement**: Public
- **Function Summary**: Retrieves custom content for the homepage, which can be Markdown text or an iframe URL

💡 Request Example:

```
const response = await fetch('/api/home_page_content', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": "# 欢迎使用New API\n\n这是一个功能强大的AI网关系统..."  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取首页内容失败"  
}
```

🧾 Field Description:

`data` (String): Homepage content, which can be Markdown text or a URL link starting with "https://"

### Model Ratio Configuration

- **Interface Name**: Model Ratio Configuration
- **HTTP Method**: GET
- **Path**: `/api/ratio_config`
- **Authentication Requirement**: Public
- **Function Summary**: Retrieves public model ratio configuration information for synchronization by upstream systems

💡 Request Example:

```
const response = await fetch('/api/ratio_config', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取倍率配置失败"  
}
```

🧾 Field Description:

`data` (Object): Ratio configuration information

- `model_ratio` (Object): Model ratio mapping, where the key is the model name and the value is the ratio numerical value
- `completion_ratio` (Object): Completion ratio mapping
- `model_price` (Object): Model price mapping, where the key is the model name and the value is the price (USD)

### Pricing and Plan Information

- **Interface Name**: Pricing and Plan Information
- **HTTP Method**: GET
- **Path**: `/api/pricing`
- **Authentication Requirement**: Anonymous/User
- **Function Summary**: Retrieves model pricing information, group ratios, and available groups

💡 Request Example:

```
const response = await fetch('/api/pricing', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_token', // Optional, logged-in users can obtain more detailed information
    'New-Api-User': 'Bearer your_user_id' // Optional
  }  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取定价信息失败"  
}
```

🧾 Field Description:

- `data` (Array): Model pricing information list

    - `model_name` (String): Model name
    - `enable_group` (Array): List of available groups
    - `model_ratio` (Number): Model Ratio
    - `completion_ratio` (Number): Completion Ratio
    - `model_price` (Number): Model Price (USD)
    - `quota_type` (Number): Billing type, 0=Ratio billing, 1=Price billing
    - `description` (String): Model description
    - `vendor_id` (Number): Vendor ID
    - `supported_endpoint_types` (Array): Supported endpoint types
- `vendors` (Array): Vendor information list

    - `id` (Number): Vendor ID
    - `name` (String): Vendor Name
    - `description` (String): Vendor description
    - `icon` (String): Vendor icon
- `group_ratio` (Object): Group ratio mapping
- `usable_group` (Object): Usable group mapping
- `supported_endpoint` (Object): Supported endpoint information
- `auto_groups` (Array): Automatic groups list

## 🔐 User Authentication

### Get Frontend Available Model List

- **Interface Name**: Get Frontend Available Model List
- **HTTP Method**: GET
- **Path**: `/api/models`
- **Authentication Requirement**: User
- **Function Summary**: Retrieves the list of AI models accessible to the current user, used for frontend Dashboard display

💡 Request Example:

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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "未授权访问"  
}
```

🧾 Field Description:

`data` (Object): Mapping of Channel ID to Model List

- Key (String): Channel ID
- Value (Array): List of model names supported by this channel