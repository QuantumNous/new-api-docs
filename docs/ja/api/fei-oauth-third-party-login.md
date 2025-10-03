## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 (日本語) | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# OAuth サードパーティログインモジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています

    本番環境では認証トークンを保護するために HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    GitHub、OIDC、LinuxDO、微信（WeChat）、Telegramなど、多様なOAuthログイン方法をサポートしています。CSRF保護とセッション管理を実装し、アカウントのバインド（紐付け）と自動登録に対応しています。フロントエンドはリダイレクト方式でOAuthフローを処理します。

## 🔐 認証不要


### GitHub OAuth リダイレクト

- **インターフェース名**：GitHub OAuth リダイレクト
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/github`
- **認証要件**：公開
- **機能概要**：GitHub OAuth コールバックを処理し、ユーザーログインまたはアカウントのバインドを完了します

💡 リクエスト例：

```
_// 前端通过重定向方式调用，通常由GitHub OAuth授权后自动回调  _window.location.href = `https://github.com/login/oauth/authorize?client_id=${github_client_id}&state=${state}&scope=user:email`;
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "ログイン成功",  
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

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "管理者が GitHub 経由のログインおよび登録を有効にしていません"  
}
```

🧾 フィールド説明：

- `code` （文字列）: GitHub OAuth 認証コード。GitHub からのコールバック時に提供されます
- `state` （文字列）: CSRF対策ステータスコード。セッションに保存されているものと一致する必要があります

### OIDC 汎用 OAuth リダイレクト

- **インターフェース名**：OIDC 汎用 OAuth リダイレクト
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/oidc`
- **認証要件**：公開
- **機能概要**：OIDC OAuth コールバックを処理し、一般的な OpenID Connect プロトコルによるログインをサポートします

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

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "ログイン成功",  
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

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "OIDC ユーザー情報の取得に失敗しました！設定を確認してください！"  
}
```

🧾 フィールド説明：

- `code` （文字列）: OIDC 認証コード
- `state` （文字列）: CSRF対策ステータスコード

### LinuxDo OAuth リダイレクト

- **インターフェース名**：LinuxDo OAuth リダイレクト
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/linuxdo`
- **認証要件**：公開
- **機能概要**：LinuxDo OAuth コールバックを処理し、LinuxDo コミュニティアカウント経由のログインをサポートします

💡 リクエスト例：

```
_// 前端通过重定向方式调用  _
window.location.href = `https://connect.linux.do/oauth2/authorize?response_type=code&client_id=${linuxdo_client_id}&state=${state}`;
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "ログイン成功",  
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

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "管理者が新規ユーザー登録を停止しています"  
}
```

🧾 フィールド説明：

- `code` （文字列）: LinuxDo OAuth 認証コード
- `state` （文字列）: CSRF対策ステータスコード
- `error` （文字列）: オプション、OAuth エラーコード
- `error_description` （文字列）: オプション、エラーの説明

### 微信 QRコードログインリダイレクト

- **インターフェース名**：微信 QRコードログインリダイレクト
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/wechat`
- **認証要件**：公開
- **機能概要**：WeChat QRコードログインを処理し、検証コードを通じてログインフローを完了します

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

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "ログイン成功",  
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

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "検証コードが無効または期限切れです"  
}
```

🧾 フィールド説明：

`code` （文字列）: WeChat QRコードスキャンで取得した検証コード

### 微信アカウントのバインド

- **インターフェース名**：微信アカウントのバインド
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/wechat/bind`
- **認証要件**：公開
- **機能概要**：WeChat アカウントを既存のユーザーアカウントにバインドします

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

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "WeChatアカウントのバインドに成功しました！"  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "検証コードが無効であるか、またはその WeChat アカウントはすでにバインドされています"  
}
```

🧾 フィールド説明：

`code` （文字列）: WeChat QRコードスキャンで取得した検証コード

### メールアドレスのバインド

- **インターフェース名**：メールアドレスのバインド
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/email/bind`
- **認証要件**：公開
- **機能概要**：メール検証コードを通じてメールアドレスをユーザーアカウントにバインドします

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

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "メールアカウントのバインドに成功しました！"  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "検証コードが無効であるか、またはそのメールアドレスは既に使用されています"  
}
```

🧾 フィールド説明：

- `email` （文字列）: バインドするメールアドレス
- `code` （文字列）: メール検証コード

### Telegram ログイン

- **インターフェース名**：Telegram ログイン
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/telegram/login`
- **認証要件**：公開
- **機能概要**：Telegram Widget を通じてユーザーログインを完了します

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

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "ログイン成功",  
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

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "Telegram認証失敗"  
}
```

🧾 フィールド説明：

- `id` （文字列）: Telegram ユーザー ID
- `first_name` （文字列）: ユーザー名（ファーストネーム）
- `last_name` （文字列）: ユーザー姓（ラストネーム）、オプション
- `username` （文字列）: Telegram ユーザー名、オプション
- `photo_url` （文字列）: アバター URL、オプション
- `auth_date` （数値）: 認証タイムスタンプ
- `hash` （文字列）: Telegram 検証ハッシュ

### Telegram アカウントのバインド

- **インターフェース名**：Telegram アカウントのバインド
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/telegram/bind`
- **認証要件**：公開
- **機能概要**：Telegram アカウントを既存のユーザーアカウントにバインドします

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

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "Telegramアカウントのバインドに成功しました！"  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "この Telegram アカウントはすでにバインドされています"  
}
```

🧾 フィールド説明：

パラメータ形式は Telegram ログインインターフェースと同じです

### ランダム state の取得（CSRF対策）

- **インターフェース名**：ランダム state の取得
- **HTTP メソッド**：GET
- **パス**：`/api/oauth/state`
- **認証要件**：公開
- **機能概要**：OAuth フローの CSRF 保護に使用するランダムな state パラメータを生成します

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

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": "random_state_string_12chars"  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "stateの生成に失敗しました"  
}
```

🧾 フィールド説明：

- `aff` （文字列）: オプション、紹介コードパラメータ。ユーザーの出所を記録するために使用されます
- `data` （文字列）: 返されるランダムな state 文字列。長さは 12 文字です