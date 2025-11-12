# OAuth サードパーティログインモジュール

!!! info "機能説明"
    APIのプレフィックスは `http(s)://<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    GitHub、OIDC、LinuxDO、WeChat（微信）、Telegram など、多様な OAuth ログイン方法をサポートしています。CSRF保護とセッション管理を実装し、アカウント連携（バインド）と自動登録に対応しています。フロントエンドはリダイレクト方式で OAuth フローを処理します。

## 🔐 認証不要

### GitHub OAuth リダイレクト

- **API名**：GitHub OAuth リダイレクト
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/github`
- **認証要件**：公開
- **機能概要**：GitHub OAuth コールバックを処理し、ユーザーログインまたはアカウント連携を完了します

💡 リクエスト例：

```
_// 前端通过重定向方式调用，通常由GitHub OAuth授权后自动回调  _window.location.href = `https://github.com/login/oauth/authorize?client_id=${github_client_id}&state=${state}&scope=user:email`;
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "github_user",  
      "display_name": "GitHub User",  
      "email": "user@example.com"  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "管理员未开启通过 GitHub 登录以及注册"  
}
```

🧾 フィールド説明：

- `code` （文字列）: GitHub OAuth 認可コード。GitHub コールバック時に提供されます
- `state` （文字列）: CSRF対策ステータスコード。セッションに保存されているものと一致する必要があります

### OIDC 汎用 OAuth リダイレクト

- **API名**：OIDC 汎用 OAuth リダイレクト
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/oidc`
- **認証要件**：公開
- **機能概要**：OIDC OAuth コールバックを処理し、汎用 OpenID Connect プロトコルによるログインをサポートします

💡 リクエスト例：

```
_// 前端通过重定向方式调用  _
const url = new URL(auth_url);  
url.searchParams.set('client_id', client_id);  
url.searchParams.set('redirect_uri', `${window.location.origin}/oauth/oidc`);  
url.searchParams.set('response_type', 'code');  
url.searchParams.set('scope', 'openid profile email');  
url.searchParams.set('state', state);  
window.location.href = url.toString();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "oidc_user",  
      "email": "user@example.com"  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "OIDC 获取用户信息失败！请检查设置！"  
}
```

🧾 フィールド説明：

- `code` （文字列）: OIDC 認可コード
- `state` （文字列）: CSRF対策ステータスコード

### LinuxDo OAuth リダイレクト

- **API名**：LinuxDo OAuth リダイレクト
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/linuxdo`
- **認証要件**：公開
- **機能概要**：LinuxDo OAuth コールバックを処理し、LinuxDoコミュニティアカウント経由のログインをサポートします

💡 リクエスト例：

```
_// 前端通过重定向方式调用  _
window.location.href = `https://connect.linux.do/oauth2/authorize?response_type=code&client_id=${linuxdo_client_id}&state=${state}`;
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "linuxdo_user",  
      "display_name": "LinuxDo User"  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "管理员关闭了新用户注册"  
}
```

🧾 フィールド説明：

- `code` （文字列）: LinuxDo OAuth 認可コード
- `state` （文字列）: CSRF対策ステータスコード
- `error` （文字列）: オプション。OAuth エラーコード
- `error_description` （文字列）: オプション。エラーの説明

### WeChat（微信）スキャンコードログインリダイレクト

- **API名**：WeChat（微信）スキャンコードログインリダイレクト
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/wechat`
- **認証要件**：公開
- **機能概要**：WeChat（微信）スキャンコードログインを処理し、検証コードを通じてログインフローを完了します

💡 リクエスト例：

```
const response = await fetch(`/api/oauth/wechat?code=${wechat_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "wechat_user",  
      "wechat_id": "wechat_openid"  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "验证码无效或已过期"  
}
```

🧾 フィールド説明：

`code` （文字列）: WeChatスキャンコードで取得した検証コード

### WeChat（微信）アカウント連携

- **API名**：WeChat（微信）アカウント連携
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/wechat/bind`
- **認証要件**：公開
- **機能概要**：WeChatアカウントを既存のユーザーアカウントに連携します

💡 リクエスト例：

```
const response = await fetch(`/api/oauth/wechat/bind?code=${wechat_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "微信账户绑定成功！"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "验证码无效或该微信账户已被绑定"  
}
```

🧾 フィールド説明：

`code` （文字列）: WeChatスキャンコードで取得した検証コード

### メールアドレス連携

- **API名**：メールアドレス連携
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/email/bind`
- **認証要件**：公開
- **機能概要**：メール検証コードを通じて、メールアドレスをユーザーアカウントに連携します

💡 リクエスト例：

```
const response = await fetch(`/api/oauth/email/bind?email=${email}&code=${email_verification_code}`, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "邮箱账户绑定成功！"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "验证码无效或邮箱已被使用"  
}
```

🧾 フィールド説明：

- `email` （文字列）: 連携するメールアドレス
- `code` （文字列）: メール検証コード

### Telegram ログイン

- **API名**：Telegram ログイン
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/telegram/login`
- **認証要件**：公開
- **機能概要**：Telegram ウィジェットを通じてユーザーログインを完了します

💡 リクエスト例：

```
const params = {  
  id: telegram_user_id,  
  first_name: "John",  
  last_name: "Doe",   
  username: "johndoe",  
  photo_url: "https://...",  
  auth_date: 1640995200,  
  hash: "telegram_hash"  
};  
const query = new URLSearchParams(params).toString();
const response = await fetch(`/api/oauth/telegram/login?${query}`, {
  method: 'GET'
});
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "telegram_user",  
      "telegram_id": "123456789"  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "Telegram验证失败"  
}
```

🧾 フィールド説明：

- `id` （文字列）: Telegram ユーザー ID
- `first_name` （文字列）: ユーザー名（名）
- `last_name` （文字列）: ユーザー名（姓）。オプション
- `username` （文字列）: Telegram ユーザー名。オプション
- `photo_url` （文字列）: アバター URL。オプション
- `auth_date` （数値）: 認証タイムスタンプ
- `hash` （文字列）: Telegram 検証ハッシュ

### Telegram アカウント連携

- **API名**：Telegram アカウント連携
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/telegram/bind`
- **認証要件**：公開
- **機能概要**：Telegramアカウントを既存のユーザーアカウントに連携します

💡 リクエスト例：

```
// 通过TelegramLoginButton组件自动处理参数  
// 参数格式与Telegram登录相同  
const response = await fetch('/api/oauth/telegram/bind', {  
  method: 'GET',  
  params: telegram_auth_params  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "Telegram账户绑定成功！"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "该Telegram账户已被绑定"  
}
```

🧾 フィールド説明：

パラメータ形式は Telegram ログイン API と同じです

### ランダム state の取得（CSRF対策）

- **API名**：ランダム state の取得
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/state`
- **認証要件**：公開
- **機能概要**：OAuthフローのCSRF保護に使用するランダムなstateパラメータを生成します

💡 リクエスト例：

```
let path = '/api/oauth/state';  
let affCode = localStorage.getItem('aff');  
if (affCode && affCode.length > 0) {  
  path += `?aff=${affCode}`;  
}  
const response = await fetch(path, {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": "random_state_string_12chars"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "生成state失败"  
}
```

🧾 フィールド説明：

- `aff` （文字列）: オプション。紹介コードパラメータ。ユーザーの出所を記録するために使用されます
- `data` （文字列）: 返されるランダムな state 文字列。長さは 12 文字です