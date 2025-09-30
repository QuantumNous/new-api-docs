# 系统初始化模块

!!! info "功能说明"
    功能接口前缀统一为 http(s)://`<your-domain>`

    系统初始化模块负责首次部署配置和运行状态监控 。支持 SQLite、MySQL、PostgreSQL 数据库，包含 Root 用户创建和系统参数初始化。状态接口提供实时系统信息，包括 OAuth 配置、功能开关等 。

## 🔐 无需鉴权

### 获取系统初始化状态

- **接口名称**：获取系统初始化状态
- **HTTP 方法**：GET
- **路径**：`/api/setup`
- **鉴权要求**：公开
- **功能简介**：检查系统是否已完成初始化，获取数据库类型和 Root 用户状态

💡 请求示例：

```
const response = await fetch('/api/setup', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "data": {  
    "status": false,  
    "root_init": true,  
    "database_type": "sqlite"  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "系统错误"  
}
```

🧾 字段说明：

- `status`（布尔型）: 系统是否已完成初始化
- `root_init`（布尔型）: Root 用户是否已存在
- `database_type`（字符串）: 数据库类型，可选值："mysql"、"postgres"、"sqlite"

### 完成首次安装向导

- **接口名称**：完成首次安装向导
- **HTTP 方法**：POST
- **路径**：`/api/setup`
- **鉴权要求**：公开
- **功能简介**：创建 Root 管理员账户并完成系统初始化配置

💡 请求示例：

```
const response = await fetch('/api/setup', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json'  
  },  
  body: JSON.stringify({  
    username: "admin",  
    password: "password123",  
    confirmPassword: "password123",  
    SelfUseModeEnabled: false,  
    DemoSiteEnabled: false  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "系统初始化完成"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "用户名长度不能超过12个字符"  
}
```

🧾 字段说明：

- `username` （字符串）: 管理员用户名，最大长度 12 个字符
- `password` （字符串）: 管理员密码，最少 8 个字符
- `confirmPassword` （字符串）: 确认密码，必须与 password 一致
- `SelfUseModeEnabled` （布尔型）: 是否启用自用模式
- `DemoSiteEnabled` （布尔型）: 是否启用演示站点模式

### 获取运行状态摘要

- **接口名称**：获取运行状态摘要
- **HTTP 方法**：GET
- **路径**：`/api/status`
- **鉴权要求**：公开
- **功能简介**：获取系统运行状态、配置信息和功能开关状态

💡 请求示例：

```
const response = await fetch('/api/status', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
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
    "version": "v1.0.0",  
    "start_time": 1640995200,  
    "email_verification": false,  
    "github_oauth": true,  
    "github_client_id": "your_client_id",  
    "system_name": "New API",  
    "quota_per_unit": 500000,  
    "display_in_currency": true,  
    "enable_drawing": true,  
    "enable_task": true,  
    "setup": true  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取状态失败"  
}
```

🧾 字段说明：

- `version` （字符串）: 系统版本号
- `start_time` （数字）: 系统启动时间戳
- `email_verification` （布尔型）: 是否启用邮箱验证
- `github_oauth` （布尔型）: 是否启用 GitHub OAuth 登录
- `github_client_id` （字符串）: GitHub OAuth 客户端 ID
- `system_name` （字符串）: 系统名称
- `quota_per_unit` （数字）: 每单位配额数量
- `display_in_currency` （布尔型）: 是否以货币形式显示
- `enable_drawing` （布尔型）: 是否启用绘图功能
- `enable_task` （布尔型）: 是否启用任务功能
- `setup` （布尔型）: 系统是否已完成初始化

### Uptime-Kuma 兼容状态探针

- **接口名称**：Uptime-Kuma 兼容状态探针
- **HTTP 方法**：GET
- **路径**：`/api/uptime/status`
- **鉴权要求**：公开
- **功能简介**：提供与 Uptime-Kuma 监控系统兼容的状态检查接口

💡 请求示例：

```
const response = await fetch('/api/uptime/status', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "data": [  
    {  
      "categoryName": "OpenAI服务",  
      "monitors": [  
        {  
          "name": "GPT-4",  
          "group": "OpenAI",  
          "status": 1,  
          "uptime": 99.5  
        }  
      ]  
    }  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取监控数据失败"  
}
```

🧾 字段说明：

- `categoryName` （字符串）: 监控分类名称
- `monitors` （数组）: 监控项列表

    - `name` （字符串）: 监控项名称
    - `group` （字符串）: 监控组名
    - `status` （数字）: 状态码，1=正常，0=异常
    - `uptime` （数字）: 可用率百分比

## 🔐 管理员鉴权

### 测试后端与依赖组件

- **接口名称**：测试后端与依赖组件
- **HTTP 方法**：GET
- **路径**：`/api/status/test`
- **鉴权要求**：管理员
- **功能简介**：测试系统各组件连接状态和健康度

💡 请求示例：

```
const response = await fetch('/api/status/test', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "所有组件测试通过",  
  "data": {  
    "database": "connected",  
    "redis": "connected",  
    "external_apis": "healthy"  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "数据库连接失败"  
}
```

🧾 字段说明：

- `database` （字符串）: 数据库连接状态
- `redis` （字符串）: Redis 连接状态
- `external_apis` （字符串）: 外部 API 健康状态