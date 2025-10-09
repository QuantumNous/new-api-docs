# 用户模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    核心用户管理系统，实现四级权限体系（公开/用户/管理员/Root）和完整的用户生命周期管理 。包含注册登录、个人资料、Token 管理、充值支付、推广系统等功能。支持 2FA、邮箱验证和多种 OAuth 登录方式。

## 账号注册/登录

### 🔐 无需鉴权

#### 注册新账号

- **接口名称**：注册新账号
- **HTTP 方法**：POST
- **路径**：`/api/user/register`
- **鉴权要求**：公开
- **功能简介**：创建新用户账户，支持邮箱验证和推荐码功能

💡 请求示例：

```
const response = await fetch('/api/user/register', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json'  
  },  
  body: JSON.stringify({  
    username: "newuser",  
    password: "password123",  
    email: "user@example.com",  
    verification_code: "123456",  
    aff_code: "INVITE123"  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "用户注册成功"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "管理员关闭了新用户注册"  
}
```

🧾 字段说明：

- `username` （字符串）: 用户名，必填
- `password` （字符串）: 密码，必填
- `email` （字符串）: 邮箱地址，当启用邮箱验证时必填 
- `verification_code` （字符串）: 邮箱验证码，当启用邮箱验证时必填
- `aff_code` （字符串）: 推荐码，可选

#### 用户登录

- **接口名称**：用户登录
- **HTTP 方法**：POST
- **路径**：`/api/user/login`
- **鉴权要求**：公开
- **功能简介**：用户账户登录，支持两步验证（2FA）

💡 请求示例：

```
const response = await fetch('/api/user/login', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json'  
  },  
  body: JSON.stringify({  
    username: "testuser",  
    password: "password123"  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例（无 2FA）：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "testuser",  
      "role": 1,  
      "quota": 1000000  
    }  
  }  
}
```

✅ 成功响应示例（需要 2FA）：

```
{  
  "success": true,  
  "message": "请输入两步验证码",  
  "data": {  
    "require_2fa": true  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "管理员关闭了密码登录"  
}
```

🧾 字段说明：

- `username` （字符串）: 用户名，必填
- `password` （字符串）: 密码，必填
- `require_2fa` （布尔型）: 是否需要两步验证 

#### Epay 支付回调

- **接口名称**：Epay 支付回调
- **HTTP 方法**：GET
- **路径**：`/api/user/epay/notify`
- **鉴权要求**：公开
- **功能简介**：处理易支付系统的支付回调通知

💡 请求示例：

```
_// 通常由支付系统自动回调，前端无需主动调用  _
_// 示例URL: /api/user/epay/notify?trade_no=USR1NO123456&money=10.00&trade_status=TRADE_SUCCESS_
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "支付成功"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "订单不存在或已处理"  
}
```

🧾 字段说明：

- `trade_no` （字符串）: 交易订单号
- `money` （字符串）: 支付金额
- `trade_status` （字符串）: 交易状态
- `sign` （字符串）: 签名验证

#### 列出所有分组（无鉴权版）

- **接口名称**：列出所有分组
- **HTTP 方法**：GET
- **路径**：`/api/user/groups`
- **鉴权要求**：公开
- **功能简介**：获取系统中所有用户分组信息，无需登录即可访问

💡 请求示例：

```
const response = await fetch('/api/user/groups', {  
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
    "default": {  
      "ratio": 1.0,  
      "desc": "默认分组"  
    },  
    "vip": {  
      "ratio": 0.8,  
      "desc": "VIP分组"  
    },  
    "auto": {  
      "ratio": "自动",  
      "desc": "自动选择最优分组"  
    }  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取分组信息失败"  
}
```

🧾 字段说明：

`data` （对象）: 分组信息映射 

- 键 （字符串）: 分组名称
- `ratio` （数字/字符串）: 分组倍率，"自动"表示自动选择
- `desc` （字符串）: 分组描述


### 🔐 用户鉴权

#### 退出登录

- **接口名称**：退出登录
- **HTTP 方法**：GET
- **路径**：`/api/user/logout`
- **鉴权要求**：用户
- **功能简介**：清除用户会话，退出登录状态

💡 请求示例：

```
const response = await fetch('/api/user/logout', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "会话清除失败"  
}
```

🧾 字段说明：

无请求参数

## 用户自身操作

### 🔐 用户鉴权

#### 获取自己所在分组

- **接口名称**：获取自己所在分组
- **HTTP 方法**：GET
- **路径**：`/api/user/self/groups`
- **鉴权要求**：用户
- **功能简介**：获取当前登录用户可使用的分组信息，包含分组倍率和描述

💡 请求示例：

```
const response = await fetch('/api/user/self/groups', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
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
  "data": {  
    "default": {  
      "ratio": 1.0,  
      "desc": "默认分组"  
    },  
    "vip": {  
      "ratio": 0.8,  
      "desc": "VIP分组"  
    },  
    "auto": {  
      "ratio": "自动",  
      "desc": "自动选择最优分组"  
    }  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取分组信息失败"  
}
```

🧾 字段说明：

`data` （对象）: 用户可用分组信息映射 group.go：25-48

- 键 （字符串）: 分组名称
- `ratio` （数字/字符串）: 分组倍率，"自动"表示自动选择最优分组
- `desc` （字符串）: 分组描述

#### 获取个人资料

- **接口名称**：获取个人资料
- **HTTP 方法**：GET
- **路径**：`/api/user/self`
- **鉴权要求**：用户
- **功能简介**：获取当前用户的详细信息，包含权限、配额、设置等

💡 请求示例：

```
const response = await fetch('/api/user/self', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
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
  "data": {  
    "id": 1,  
    "username": "testuser",  
    "display_name": "Test User",  
    "role": 1,  
    "status": 1,  
    "email": "user@example.com",  
    "group": "default",  
    "quota": 1000000,  
    "used_quota": 50000,  
    "request_count": 100,  
    "aff_code": "ABC123",  
    "aff_count": 5,  
    "aff_quota": 10000,  
    "aff_history_quota": 50000,  
    "inviter_id": 0,  
    "linux_do_id": "",  
    "setting": "{}",  
    "stripe_customer": "",  
    "sidebar_modules": "{\"chat\":{\"enabled\":true}}",  
    "permissions": {  
      "can_view_logs": true,  
      "can_manage_tokens": true  
    }  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取用户信息失败"  
}
```

🧾 字段说明：

- `id` （数字）: 用户 ID
- `username` （字符串）: 用户名
- `display_name` （字符串）: 显示名称
- `role` （数字）: 用户角色，1=普通用户，10=管理员，100=Root 用户
- `status` （数字）: 用户状态，1=正常，2=禁用
- `email` （字符串）: 邮箱地址
- `group` （字符串）: 所属分组
- `quota` （数字）: 总配额
- `used_quota` （数字）: 已使用配额
- `request_count` （数字）: 请求次数
- `aff_code` （字符串）: 推荐码
- `aff_count` （数字）: 推荐人数
- `aff_quota` （数字）: 推荐奖励配额
- `aff_history_quota` （数字）: 历史推荐配额
- `inviter_id` （数字）: 邀请人 ID
- `linux_do_id` （字符串）: LinuxDo 账户 ID
- `setting` （字符串）: 用户设置 JSON 字符串
- `stripe_customer` （字符串）: Stripe 客户 ID
- `sidebar_modules` （字符串）: 侧边栏模块配置 JSON 字符串 
- `permissions` （对象）: 用户权限信息


#### 获取模型可见性

- **接口名称**：获取模型可见性
- **HTTP 方法**：GET
- **路径**：`/api/user/models`
- **鉴权要求**：用户
- **功能简介**：获取当前用户可访问的 AI 模型列表

💡 请求示例：

```
const response = await fetch('/api/user/models', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
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
    "gpt-3.5-turbo",  
    "gpt-4",  
    "claude-3-sonnet",  
    "claude-3-haiku"  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取模型列表失败"  
}
```

🧾 字段说明：

`data` （数组）: 用户可访问的模型名称列表 

#### 修改个人资料

- **接口名称**：修改个人资料
- **HTTP 方法**：PUT
- **路径**：`/api/user/self`
- **鉴权要求**：用户
- **功能简介**：更新用户个人信息或侧边栏设置

💡 请求示例（更新个人信息）：

```
const response = await fetch('/api/user/self', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    display_name: "New Display Name",  
    email: "newemail@example.com"  
  })  
});  
const data = await response.json();
```

💡 请求示例（更新侧边栏设置）：

```
const response = await fetch('/api/user/self', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    sidebar_modules: JSON.stringify({  
      chat: { enabled: true, playground: true },  
      console: { enabled: true, token: true }  
    })  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "更新成功"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "输入不合法"  
}
```

🧾 字段说明：

- `display_name` （字符串）: 显示名称，可选
- `email` （字符串）: 邮箱地址，可选
- `password` （字符串）: 新密码，可选
- `sidebar_modules` （字符串）: 侧边栏模块配置 JSON 字符串，可选 

#### 注销账号

- **接口名称**：注销账号
- **HTTP 方法**：DELETE
- **路径**：`/api/user/self`
- **鉴权要求**：用户
- **功能简介**：删除当前用户账户，Root 用户不可删除

💡 请求示例：

```
const response = await fetch('/api/user/self', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "不能删除超级管理员账户"  
}
```

🧾 字段说明：

无请求参数

#### 生成用户级别 Access Token

- **接口名称**：生成用户级别 Access Token
- **HTTP 方法**：GET
- **路径**：`/api/user/token`
- **鉴权要求**：用户
- **功能简介**：为当前用户生成新的访问令牌，用于 API 调用

💡 请求示例：

```
const response = await fetch('/api/user/token', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
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
  "data": "<YOUR_API_KEY>"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "生成令牌失败"  
}
```

🧾 字段说明：

`data` （字符串）: 生成的访问令牌

#### 获取推广码信息

- **接口名称**：获取推广码信息
- **HTTP 方法**：GET
- **路径**：`/api/user/aff`
- **鉴权要求**：用户
- **功能简介**：获取或生成用户的推广码，用于邀请新用户注册

💡 请求示例：

```
const response = await fetch('/api/user/aff', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
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
  "data": "ABC123"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取推广码失败"  
}
```

🧾 字段说明：

`data` （字符串）: 用户的推广码，如果不存在会自动生成 4 位随机字符串

#### 余额直充

- **接口名称**：余额直充
- **HTTP 方法**：POST
- **路径**：`/api/user/topup`
- **鉴权要求**：用户
- **功能简介**：使用兑换码为账户充值配额

💡 请求示例：

```
const response = await fetch('/api/user/topup', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    key: "REDEEM123456"  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "兑换成功",  
  "data": 100000  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "兑换码无效或已使用"  
}
```

🧾 字段说明：

- `key` （字符串）: 兑换码，必填
- `data` （数字）: 成功时返回兑换的配额数量

#### 提交支付订单

- **接口名称**：提交支付订单
- **HTTP 方法**：POST
- **路径**：`/api/user/pay`
- **鉴权要求**：用户
- **功能简介**：创建在线支付订单，支持多种支付方式

💡 请求示例：

```
const response = await fetch('/api/user/pay', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    amount: 10000,  
    payment_method: "alipay",  
    top_up_code: ""  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "success",  
  "data": {  
    "pid": "12345",  
    "type": "alipay",  
    "out_trade_no": "USR1NO123456",  
    "notify_url": "https://example.com/notify",  
    "return_url": "https://example.com/return",  
    "name": "TUC10000",  
    "money": "10.00",  
    "sign": "abc123def456"  
  },  
  "url": "https://pay.example.com/submit"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "充值数量不能小于 1000"  
}
```

🧾 字段说明：

- `amount` （数字）: 充值数量，必须大于等于最小充值额度 topup.go：133-136
- `payment_method` （字符串）: 支付方式，如"alipay"、"wxpay"等
- `top_up_code` （字符串）: 充值码，可选
- `data` （对象）: 支付表单参数
- `url` （字符串）: 支付提交地址

#### 余额支付

- **接口名称**：余额支付
- **HTTP 方法**：POST
- **路径**：`/api/user/amount`
- **鉴权要求**：用户
- **功能简介**：计算指定充值数量对应的实际支付金额

💡 请求示例：

```
const response = await fetch('/api/user/amount', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    amount: 10000,  
    top_up_code: ""  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "success",  
  "data": "10.00"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "充值数量不能小于 1000"  
}
```

🧾 字段说明：

- `amount` （数字）: 充值数量，必须大于等于最小充值额度 
- `top_up_code` （字符串）: 充值码，可选
- `data` （字符串）: 实际需要支付的金额（元）

#### 推广额度转账

- **接口名称**：推广额度转账
- **HTTP 方法**：POST
- **路径**：`/api/user/aff_transfer`
- **鉴权要求**：用户
- **功能简介**：将推广奖励额度转换为可用配额

💡 请求示例：

```
const response = await fetch('/api/user/aff_transfer', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    quota: 50000  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "划转成功"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "邀请额度不足！"  
}
```

🧾 字段说明：

`quota` （数字）: 要转换的额度数量，必须大于等于最小单位额度 

#### 更新用户设置

- **接口名称**：更新用户设置
- **HTTP 方法**：PUT
- **路径**：`/api/user/setting`
- **鉴权要求**：用户
- **功能简介**：更新用户的个人设置配置

💡 请求示例：

```
const response = await fetch('/api/user/setting', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    theme: "dark",  
    language: "zh-CN",  
    notifications: {  
      email: true,  
      browser: false  
    }  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "设置更新成功"  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "设置格式错误"  
}
```

🧾 字段说明：

- 请求体可包含任意用户设置字段，以 JSON 格式提交
- 具体字段根据前端设置页面的需求而定

## 管理员用户管理

### 🔐 管理员鉴权

#### 获取全部用户列表

- **接口名称**：获取全部用户列表
- **HTTP 方法**：GET
- **路径**：`/api/user/`
- **鉴权要求**：管理员
- **功能简介**：分页获取系统中所有用户的列表信息

💡 请求示例：

```
const response = await fetch('/api/user/?p=1&page_size=20', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
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
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "username": "testuser",  
        "display_name": "Test User",  
        "role": 1,  
        "status": 1,  
        "email": "user@example.com",  
        "group": "default",  
        "quota": 1000000,  
        "used_quota": 50000,  
        "request_count": 100  
      }  
    ],  
    "total": 50,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取用户列表失败"  
}
```

🧾 字段说明：

- `p` （数字）: 页码，默认为 1
- `page_size` （数字）: 每页数量，默认为 20
- `items` （数组）: 用户信息列表
- `total` （数字）: 用户总数
- `page` （数字）: 当前页码
- `page_size` （数字）: 每页数量

#### 搜索用户

- **接口名称**：搜索用户
- **HTTP 方法**：GET
- **路径**：`/api/user/search`
- **鉴权要求**：管理员
- **功能简介**：根据关键词和分组搜索用户

💡 请求示例：

```
const response = await fetch('/api/user/search?keyword=test&group=default&p=1&page_size=20', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
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
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "username": "testuser",  
        "display_name": "Test User",  
        "role": 1,  
        "status": 1,  
        "email": "test@example.com",  
        "group": "default"  
      }  
    ],  
    "total": 1,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "搜索用户失败"  
}
```

🧾 字段说明：

- `keyword` （字符串）: 搜索关键词，可匹配用户名、显示名、邮箱
- `group` （字符串）: 用户分组过滤条件
- `p` （数字）: 页码，默认为 1
- `page_size` （数字）: 每页数量，默认为 20

#### 获取单个用户信息

- **接口名称**：获取单个用户信息
- **HTTP 方法**：GET
- **路径**：`/api/user/:id`
- **鉴权要求**：管理员
- **功能简介**：获取指定用户的详细信息，包含权限检查

💡 请求示例：

```
const response = await fetch('/api/user/123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
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
  "data": {  
    "id": 123,  
    "username": "targetuser",  
    "display_name": "Target User",  
    "role": 1,  
    "status": 1,  
    "email": "target@example.com",  
    "group": "default",  
    "quota": 1000000,  
    "used_quota": 50000,  
    "request_count": 100,  
    "aff_code": "ABC123",  
    "aff_count": 5  
  }  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "无权获取同级或更高等级用户的信息"  
}
```

🧾 字段说明：

- `id` （数字）: 用户 ID，通过 URL 路径传递
- 返回完整的用户信息，但管理员无法查看同级或更高权限用户的信息 

#### 创建用户

- **接口名称**：创建用户
- **HTTP 方法**：POST
- **路径**：`/api/user/`
- **鉴权要求**：管理员
- **功能简介**：创建新用户账户，管理员不能创建权限大于等于自己的用户

💡 请求示例：

```
const response = await fetch('/api/user/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id' 
  },  
  body: JSON.stringify({  
    username: "newuser",  
    password: "password123",  
    display_name: "New User",  
    role: 1  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "无法创建权限大于等于自己的用户"  
}
```

🧾 字段说明：

- `username` （字符串）: 用户名，必填
- `password` （字符串）: 密码，必填
- `display_name` （字符串）: 显示名称，可选，默认为用户名
- `role` （数字）: 用户角色，必须小于当前管理员角色 

#### 冻结/重置等管理操作

- **接口名称**：冻结/重置等管理操作
- **HTTP 方法**：POST
- **路径**：`/api/user/manage`
- **鉴权要求**：管理员
- **功能简介**：对用户执行管理操作，包括启用、禁用、删除、提升、降级等

💡 请求示例：

```
const response = await fetch('/api/user/manage', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    id: 123,  
    action: "disable"  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "无法禁用超级管理员用户"  
}
```

🧾 字段说明：

- `id` （数字）: 目标用户 ID，必填
- `action` （字符串）: 操作类型，必填，可选值：

    - `disable`： 禁用用户 
    - `enable`： 启用用户 
    - `delete`： 删除用户 
    - `promote`： 提升为管理员（仅 Root 用户可操作） 
    - `demote`： 降级为普通用户 

#### 更新用户

- **接口名称**：更新用户
- **HTTP 方法**：PUT
- **路径**：`/api/user/`
- **鉴权要求**：管理员
- **功能简介**：更新用户信息，包含权限检查和配额变更记录

💡 请求示例：

```
const response = await fetch('/api/user/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    id: 123,  
    username: "updateduser",  
    display_name: "Updated User",  
    email: "updated@example.com",  
    quota: 2000000,  
    role: 1,  
    status: 1  
  })  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "无权更新同权限等级或更高权限等级的用户信息"  
}
```

🧾 字段说明：

- `id` （数字）: 用户 ID，必填
- `username` （字符串）: 用户名，可选
- `display_name` （字符串）: 显示名称，可选
- `email` （字符串）: 邮箱地址，可选
- `password` （字符串）: 新密码，可选，为空则不更新密码
- `quota` （数字）: 用户配额，可选
- `role` （数字）: 用户角色，不能大于等于当前管理员角色 
- `status` （数字）: 用户状态，可选

#### 删除用户

- **接口名称**：删除用户
- **HTTP 方法**：DELETE
- **路径**：`/api/user/:id`
- **鉴权要求**：管理员
- **功能简介**：硬删除指定用户，管理员不能删除同级或更高权限用户

💡 请求示例：

```
const response = await fetch('/api/user/123', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "无权删除同权限等级或更高权限等级的用户"  
}
```

🧾 字段说明：

- `id` （数字）: 用户 ID，通过 URL 路径传递
- 执行硬删除操作，不可恢复 

