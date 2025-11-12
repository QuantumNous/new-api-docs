# Email Authentication Module

!!! info "Feature Description"
    The interface prefix is uniformly http(s)://`<your-domain>`

    HTTPS should be used in production environments to secure authentication tokens. HTTP is only recommended for development environments.

    Implements email verification and password reset functionalities, integrating rate limiting and Turnstile protection. Supports automatic generation of random passwords and email template customization. Widely used in scenarios such as user registration and account binding.

## 🔐 No Authentication Required

### Send Email Verification Mail

- **Interface Name**: Send Email Verification Mail
- **HTTP Method**: GET
- **Path**: `/api/verification`
- **Authentication Requirement**: Public (Rate Limited)
- **Function Description**: Sends an email verification code to the specified email address, used for email binding or verification operations.

💡 Request Example:

```
const response = await fetch(`/api/verification?email=${email}&turnstile=${turnstileToken}`, {  
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
  "message": ""  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "无效的参数"  
}
```

🧾 Field Description:

- `email` (String): The email address receiving the verification code; must be a valid email format.
- `turnstile` (String): Turnstile verification token, used to prevent bot attacks.

### Send Reset Password Mail

- **Interface Name**: Send Reset Password Mail
- **HTTP Method**: GET
- **Path**: `/api/reset_password`
- **Authentication Requirement**: Public (Rate Limited)
- **Function Description**: Sends a password reset link to a registered email address, used for users to recover their password.

💡 Request Example:

```
const response = await fetch(`/api/reset_password?email=${email}&turnstile=${turnstileToken}`, {  
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
  "message": ""  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "该邮箱地址未注册"  
}
```

🧾 Field Description:

- `email` (String): The email address requiring password reset; must be a registered email.
- `turnstile` (String): Turnstile verification token, used to prevent malicious requests.

### Submit Reset Password Request

- **Interface Name**: Submit Reset Password Request
- **HTTP Method**: POST
- **Path**: `/api/user/reset`
- **Authentication Requirement**: Public
- **Function Description**: Completes the password reset using the reset link provided in the email. The system generates and returns a new password.

💡 Request Example:

```
const response = await fetch('/api/user/reset', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json'  
  },  
  body: JSON.stringify({  
    email: "user@example.com",  
    token: "verification_token_from_email"  
  })  
});  
const data = await response.json();
```

✅ Successful Response Example:

```
{  
  "success": true,  
  "message": "",  
  "data": "newPassword123"  
}
```

❗ Failure Response Example:

```
{  
  "success": false,  
  "message": "重置链接非法或已过期"  
}
```

🧾 Field Description:

- `email` (String): The email address for which the password is to be reset.
- `token` (String): The verification token obtained from the reset email.
- `data` (String): The new password returned upon success. The system automatically generates a 12-digit random password.