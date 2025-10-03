## Core Concepts

| 中文 | English | 说明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 用于计算价格的乘数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | API access credentials, also refers to text units processed by models | API access credentials or text units processed by models |
| 渠道 | Channel | API服务提供商的接入通道 | Access channel for API service providers |
| 分组 | Group | 用户或令牌的分类，影响价格倍率 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | 用户可用的服务额度 | Available service quota for users |

# User Module

!!! info "Feature Description"
    The API prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    The core user management system implements a four-tier permission structure (Public/User/Admin/Root) and complete user lifecycle management. It includes features such as registration/login, personal profile, Token management, top-up/payment, and an affiliate system. It supports 2FA, email verification, and various OAuth login methods.

## Account Registration/Login

### 🔐 Public Endpoints (No Authentication Required)

#### Register New Account

- **Endpoint Name**: Register New Account
- **HTTP Method**: POST
- **Path**: `/api/user/register`
- **Authentication Requirement**: Public
- **Description**: Creates a new user account, supporting email verification and referral code functionality

💡 Request Example:

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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "用户注册成功"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "管理员关闭了新用户注册"  
}
```

🧾 Field Description:

- `username` (String): Username, required
- `password` (String): Password, required
- `email` (String): Email address, required when email verification is enabled 
- `verification_code` (String): Email verification code, required when email verification is enabled
- `aff_code` (String): Referral code, optional

#### User Login

- **Endpoint Name**: User Login
- **HTTP Method**: POST
- **Path**: `/api/user/login`
- **Authentication Requirement**: Public
- **Description**: User account login, supporting Two-Factor Authentication (2FA)

💡 Request Example:

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

✅ Successful Response Example (No 2FA):

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

✅ Successful Response Example (2FA Required):

```
{  
  "success": true,  
  "message": "请输入两步验证码",  
  "data": {  
    "require_2fa": true  
  }  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "管理员关闭了密码登录"  
}
```

🧾 Field Description:

- `username` (String): Username, required
- `password` (String): Password, required
- `require_2fa` (Boolean): Whether two-factor authentication is required 

#### Epay Payment Notification

- **Endpoint Name**: Epay Payment Notification
- **HTTP Method**: GET
- **Path**: `/api/user/epay/notify`
- **Authentication Requirement**: Public
- **Description**: Handles payment callback notifications from the Epay system.

💡 Request Example:

```
_// 通常由支付系统自动回调，前端无需主动调用  _
_// 示例URL: /api/user/epay/notify?trade_no=USR1NO123456&money=10.00&trade_status=TRADE_SUCCESS_
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "支付成功"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "订单不存在或已处理"  
}
```

🧾 Field Description:

- `trade_no` (String): Transaction order number
- `money` (String): Payment amount
- `trade_status` (String): Transaction status
- `sign` (String): Signature verification

#### List All Groups (Unauthenticated)

- **Endpoint Name**: List All Groups
- **HTTP Method**: GET
- **Path**: `/api/user/groups`
- **Authentication Requirement**: Public
- **Description**: Retrieves information about all user groups in the system, accessible without logging in.

💡 Request Example:

```
const response = await fetch('/api/user/groups', {  
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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取分组信息失败"  
}
```

🧾 Field Description:

`data` (Object): Group information mapping 

- Key (String): Group name
- `ratio` (Number/String): Group ratio, "自动" (auto) indicates automatic selection
- `desc` (String): Group description


### 🔐 User Authentication Required

#### Logout

- **Endpoint Name**: Logout
- **HTTP Method**: GET
- **Path**: `/api/user/logout`
- **Authentication Requirement**: User
- **Description**: Clears the user session and logs the user out.

💡 Request Example:

```
const response = await fetch('/api/user/logout', {  
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
  "message": ""  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "会话清除失败"  
}
```

🧾 Field Description:

No request parameters

## User Self-Service Operations

### 🔐 User Authentication Required

#### Get Own Groups

- **Endpoint Name**: Get Own Groups
- **HTTP Method**: GET
- **Path**: `/api/user/self/groups`
- **Authentication Requirement**: User
- **Description**: Retrieves the group information available to the currently logged-in user, including group ratio and description.

💡 Request Example:

```
const response = await fetch('/api/user/self/groups', {  
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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取分组信息失败"  
}
```

🧾 Field Description:

`data` (Object): User available group information mapping group.go：25-48

- Key (String): Group name
- `ratio` (Number/String): Group ratio, "自动" (auto) indicates automatic selection of the optimal group
- `desc` (String): Group description

#### Get Personal Profile

- **Endpoint Name**: Get Personal Profile
- **HTTP Method**: GET
- **Path**: `/api/user/self`
- **Authentication Requirement**: User
- **Description**: Retrieves detailed information about the current user, including permissions, quota, settings, etc.

💡 Request Example:

```
const response = await fetch('/api/user/self', {  
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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取用户信息失败"  
}
```

🧾 Field Description:

- `id` (Number): User ID
- `username` (String): Username
- `display_name` (String): Display name
- `role` (Number): User role, 1=Standard User, 10=Admin, 100=Root User
- `status` (Number): User status, 1=Normal, 2=Disabled
- `email` (String): Email address
- `group` (String): Assigned Group
- `quota` (Number): Total Quota
- `used_quota` (Number): Used Quota
- `request_count` (Number): Request Count
- `aff_code` (String): Affiliate Code
- `aff_count` (Number): Affiliate Count
- `aff_quota` (Number): Affiliate Reward Quota
- `aff_history_quota` (Number): Historical Affiliate Quota
- `inviter_id` (Number): Inviter ID
- `linux_do_id` (String): LinuxDo Account ID
- `setting` (String): User settings JSON string
- `stripe_customer` (String): Stripe Customer ID
- `sidebar_modules` (String): Sidebar module configuration JSON string 
- `permissions` (Object): User permission information


#### Get Model Visibility

- **Endpoint Name**: Get Model Visibility
- **HTTP Method**: GET
- **Path**: `/api/user/models`
- **Authentication Requirement**: User
- **Description**: Retrieves the list of AI models accessible to the current user.

💡 Request Example:

```
const response = await fetch('/api/user/models', {  
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
  "message": "",  
  "data": [  
    "gpt-3.5-turbo",  
    "gpt-4",  
    "claude-3-sonnet",  
    "claude-3-haiku"  
  ]  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取模型列表失败"  
}
```

🧾 Field Description:

`data` (Array): List of model names accessible to the user 

#### Modify Personal Profile

- **Endpoint Name**: Modify Personal Profile
- **HTTP Method**: PUT
- **Path**: `/api/user/self`
- **Authentication Requirement**: User
- **Description**: Updates user personal information or sidebar settings.

💡 Request Example (Update Personal Information):

```
const response = await fetch('/api/user/self', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    display_name: "New Display Name",  
    email: "newemail@example.com"  
  })  
});  
const data = await response.json();
```

💡 Request Example (Update Sidebar Settings):

```
const response = await fetch('/api/user/self', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "更新成功"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "输入不合法"  
}
```

🧾 Field Description:

- `display_name` (String): Display name, optional
- `email` (String): Email address, optional
- `password` (String): New password, optional
- `sidebar_modules` (String): Sidebar module configuration JSON string, optional 

#### Deactivate Account

- **Endpoint Name**: Deactivate Account
- **HTTP Method**: DELETE
- **Path**: `/api/user/self`
- **Authentication Requirement**: User
- **Description**: Deletes the current user account. Root users cannot be deleted.

💡 Request Example:

```
const response = await fetch('/api/user/self', {  
  method: 'DELETE',  
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
  "message": ""  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "不能删除超级管理员账户"  
}
```

🧾 Field Description:

No request parameters

#### Generate User-Level Access Token

- **Endpoint Name**: Generate User-Level Access Token
- **HTTP Method**: GET
- **Path**: `/api/user/token`
- **Authentication Requirement**: User
- **Description**: Generates a new access token for the current user, used for API calls.

💡 Request Example:

```
const response = await fetch('/api/user/token', {  
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
  "message": "",  
  "data": "<YOUR_API_KEY>"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "生成令牌失败"  
}
```

🧾 Field Description:

`data` (String): Generated access token

#### Get Affiliate Code Information

- **Endpoint Name**: Get Affiliate Code Information
- **HTTP Method**: GET
- **Path**: `/api/user/aff`
- **Authentication Requirement**: User
- **Description**: Retrieves or generates the user's affiliate code, used for inviting new users to register.

💡 Request Example:

```
const response = await fetch('/api/user/aff', {  
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
  "message": "",  
  "data": "ABC123"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取推广码失败"  
}
```

🧾 Field Description:

`data` (String): The user's affiliate code. If it does not exist, a 4-digit random string will be automatically generated.

#### Direct Quota Top-up

- **Endpoint Name**: Direct Quota Top-up
- **HTTP Method**: POST
- **Path**: `/api/user/topup`
- **Authentication Requirement**: User
- **Description**: Uses a redemption code to top up the account quota.

💡 Request Example:

```
const response = await fetch('/api/user/topup', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    key: "REDEEM123456"  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "兑换成功",  
  "data": 100000  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "兑换码无效或已使用"  
}
```

🧾 Field Description:

- `key` (String): Redemption code, required
- `data` (Number): Returns the amount of quota redeemed upon success

#### Submit Payment Order

- **Endpoint Name**: Submit Payment Order
- **HTTP Method**: POST
- **Path**: `/api/user/pay`
- **Authentication Requirement**: User
- **Description**: Creates an online payment order, supporting various payment methods.

💡 Request Example:

```
const response = await fetch('/api/user/pay', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    amount: 10000,  
    payment_method: "alipay",  
    top_up_code: ""  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "充值数量不能小于 1000"  
}
```

🧾 Field Description:

- `amount` (Number): Top-up amount, must be greater than or equal to the minimum top-up quota topup.go：133-136
- `payment_method` (String): Payment method, such as "alipay", "wxpay", etc.
- `top_up_code` (String): Top-up code, optional
- `data` (Object): Payment form parameters
- `url` (String): Payment submission URL

#### Calculate Payment Amount

- **Endpoint Name**: Calculate Payment Amount
- **HTTP Method**: POST
- **Path**: `/api/user/amount`
- **Authentication Requirement**: User
- **Description**: Calculates the actual payment amount corresponding to the specified top-up quota.

💡 Request Example:

```
const response = await fetch('/api/user/amount', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    amount: 10000,  
    top_up_code: ""  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "success",  
  "data": "10.00"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "充值数量不能小于 1000"  
}
```

🧾 Field Description:

- `amount` (Number): Top-up amount, must be greater than or equal to the minimum top-up quota 
- `top_up_code` (String): Top-up code, optional
- `data` (String): Actual amount required for payment (Yuan)

#### Affiliate Quota Transfer

- **Endpoint Name**: Affiliate Quota Transfer
- **HTTP Method**: POST
- **Path**: `/api/user/aff_transfer`
- **Authentication Requirement**: User
- **Description**: Converts affiliate reward quota into usable quota.

💡 Request Example:

```
const response = await fetch('/api/user/aff_transfer', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    quota: 50000  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "划转成功"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "邀请额度不足！"  
}
```

🧾 Field Description:

`quota` (Number): The amount of quota to convert, must be greater than or equal to the minimum unit quota 

#### Update User Settings

- **Endpoint Name**: Update User Settings
- **HTTP Method**: PUT
- **Path**: `/api/user/setting`
- **Authentication Requirement**: User
- **Description**: Updates the user's personal settings configuration.

💡 Request Example:

```
const response = await fetch('/api/user/setting', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "设置更新成功"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "设置格式错误"  
}
```

🧾 Field Description:

- The request body can contain any user setting fields, submitted in JSON format
- Specific fields depend on the requirements of the frontend settings page

## Administrator User Management

### 🔐 Administrator Authentication Required

#### Get All Users List

- **Endpoint Name**: Get All Users List
- **HTTP Method**: GET
- **Path**: `/api/user/`
- **Authentication Requirement**: Administrator
- **Description**: Retrieves a paginated list of all users in the system.

💡 Request Example:

```
const response = await fetch('/api/user/?p=1&page_size=20', {  
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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "获取用户列表失败"  
}
```

🧾 Field Description:

- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20
- `items` (Array): List of user information
- `total` (Number): Total number of users
- `page` (Number): Current page number
- `page_size` (Number): Items per page

#### Search Users

- **Endpoint Name**: Search Users
- **HTTP Method**: GET
- **Path**: `/api/user/search`
- **Authentication Requirement**: Administrator
- **Description**: Searches for users based on keywords and groups.

💡 Request Example:

```
const response = await fetch('/api/user/search?keyword=test&group=default&p=1&page_size=20', {  
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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "搜索用户失败"  
}
```

🧾 Field Description:

- `keyword` (String): Search keyword, can match username, display name, or email
- `group` (String): User group filter condition
- `p` (Number): Page number, defaults to 1
- `page_size` (Number): Items per page, defaults to 20

#### Get Single User Information

- **Endpoint Name**: Get Single User Information
- **HTTP Method**: GET
- **Path**: `/api/user/:id`
- **Authentication Requirement**: Administrator
- **Description**: Retrieves detailed information for a specified user, including permission checks.

💡 Request Example:

```
const response = await fetch('/api/user/123', {  
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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "无权获取同级或更高等级用户的信息"  
}
```

🧾 Field Description:

- `id` (Number): User ID, passed via URL path
- Returns complete user information, but administrators cannot view information for users of the same or higher role level. 

#### Create User

- **Endpoint Name**: Create User
- **HTTP Method**: POST
- **Path**: `/api/user/`
- **Authentication Requirement**: Administrator
- **Description**: Creates a new user account. Administrators cannot create users with a role level greater than or equal to their own.

💡 Request Example:

```
const response = await fetch('/api/user/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "无法创建权限大于等于自己的用户"  
}
```

🧾 Field Description:

- `username` (String): Username, required
- `password` (String): Password, required
- `display_name` (String): Display name, optional, defaults to username
- `role` (Number): User role, must be less than the current administrator's role 

#### Management Operations: Disable/Reset, etc.

- **Endpoint Name**: Management Operations: Disable/Reset, etc.
- **HTTP Method**: POST
- **Path**: `/api/user/manage`
- **Authentication Requirement**: Administrator
- **Description**: Performs management operations on a user, including enabling, disabling, deleting, promoting, and demoting.

💡 Request Example:

```
const response = await fetch('/api/user/manage', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    action: "disable"  
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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "无法禁用超级管理员用户"  
}
```

🧾 Field Description:

- `id` (Number): Target User ID, required
- `action` (String): Action type, required, possible values:

    - `disable`: Disable user 
    - `enable`: Enable user 
    - `delete`: Delete user 
    - `promote`: Promote to Administrator (Root users only) 
    - `demote`: Demote to Standard User 

#### Update User

- **Endpoint Name**: Update User
- **HTTP Method**: PUT
- **Path**: `/api/user/`
- **Authentication Requirement**: Administrator
- **Description**: Updates user information, including permission checks and quota change logging.

💡 Request Example:

```
const response = await fetch('/api/user/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": ""  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "无权更新同权限等级或更高权限等级的用户信息"  
}
```

🧾 Field Description:

- `id` (Number): User ID, required
- `username` (String): Username, optional
- `display_name` (String): Display name, optional
- `email` (String): Email address, optional
- `password` (String): New password, optional. If empty, the password is not updated.
- `quota` (Number): User quota, optional
- `role` (Number): User role, cannot be greater than or equal to the current administrator's role 
- `status` (Number): User status, optional

#### Delete User

- **Endpoint Name**: Delete User
- **HTTP Method**: DELETE
- **Path**: `/api/user/:id`
- **Authentication Requirement**: Administrator
- **Description**: Hard deletes the specified user. Administrators cannot delete users of the same or higher role level.

💡 Request Example:

```
const response = await fetch('/api/user/123', {  
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

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "无权删除同权限等级或更高权限等级的用户"  
}
```

🧾 Field Description:

- `id` (Number): User ID, passed via URL path
- Performs a hard delete operation, irreversible