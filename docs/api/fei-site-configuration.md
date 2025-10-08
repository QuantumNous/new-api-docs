# 站点配置模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    最高权限的系统配置管理，仅 Root 用户可访问 。包含全局参数配置、模型倍率重置、控制台设置迁移等功能。配置更新包含严格的依赖验证逻辑。

## 🔐 Root鉴权

### 获取全局配置
- **接口名称**：获取全局配置
- **HTTP 方法**：GET
- **路径**：`/api/option/`
- **鉴权要求**：Root
- **功能简介**：获取系统所有全局配置选项，过滤敏感信息如 Token、Secret、Key 等
💡 请求示例：

```
const response = await fetch('/api/option/', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
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
      "key": "SystemName",  
      "value": "New API"  
    },  
    {  
      "key": "DisplayInCurrencyEnabled",  
      "value": "true"  
    },  
    {  
      "key": "QuotaPerUnit",  
      "value": "500000"  
    }  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取配置失败"  
}
```

🧾 字段说明：

`data` （数组）: 配置项列表 option.go：15-18

- `key` （字符串）: 配置项键名
- `value` （字符串）: 配置项值，敏感信息已过滤 option.go：22-24


### 更新全局配置

- **接口名称**：更新全局配置
- **HTTP 方法**：PUT
- **路径**：`/api/option/`
- **鉴权要求**：Root
- **功能简介**：更新单个全局配置项，包含配置验证和依赖检查

💡 请求示例：

```
const response = await fetch('/api/option/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    key: "SystemName",  
    value: "My New API System"  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "配置更新成功"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "无法启用 GitHub OAuth，请先填入 GitHub Client Id 以及 GitHub Client Secret！"  
}
```

🧾 字段说明：

- `key` （字符串）: 配置项键名，必填 option.go：39-42
- `value` （任意类型）: 配置项值，支持布尔型、数字、字符串等类型 option.go：54-63

### 重置模型倍率

- **接口名称**：重置模型倍率
- **HTTP 方法**：POST
- **路径**：`/api/option/rest_model_ratio`
- **鉴权要求**：Root
- **功能简介**：重置所有模型的倍率配置到默认值，用于批量重置模型定价

💡 请求示例：

```
const response = await fetch('/api/option/rest_model_ratio', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "模型倍率重置成功"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "重置模型倍率失败"  
}
```

🧾 字段说明：

无请求参数，执行后会重置所有模型倍率配置

### 迁移旧版控制台配置

- **接口名称**：迁移旧版控制台配置
- **HTTP 方法**：POST
- **路径**：`/api/option/migrate_console_setting`
- **鉴权要求**：Root
- **功能简介**：将旧版本的控制台配置迁移到新的配置格式，包括 API 信息、公告、FAQ 等

💡 请求示例：

```
const response = await fetch('/api/option/migrate_console_setting', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "migrated"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "迁移失败"  
}
```

🧾 字段说明：

- 无请求参数
- 迁移内容包括：

    - `ApiInfo` → `console_setting.api_info` 
    - `Announcements` → `console_setting.announcements` 
    - `FAQ` → `console_setting.faq` 
    - `UptimeKumaUrl/UptimeKumaSlug` → `console_setting.uptime_kuma_groups` 


