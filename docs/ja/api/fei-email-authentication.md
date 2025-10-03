# メール認証モジュール

!!! info "機能説明"
    APIプレフィックスは http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    メール検証およびパスワードリセット機能を実装し、レート制限と Turnstile 保護を統合しています。ランダムなパスワードの自動生成とメールテンプレートのカスタマイズをサポートします。ユーザー登録、アカウント連携などのシナリオで広く使用されます。

## 🔐 認証不要

### メール検証メールの送信

- **API名**：メール検証メールの送信
- **HTTP メソッド**：GET
- **パス**：`/api/verification`
- **認証要件**：公開 （レート制限あり）
- **機能概要**：指定されたメールアドレスにメール検証コードを送信します。メール連携または検証操作に使用されます。

💡 リクエスト例：

```
const response = await fetch(`/api/verification?email=${email}&turnstile=${turnstileToken}`, {  
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
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "无效的参数"  
}
```

🧾 フィールド説明：

- `email` （文字列）: 検証コードを受信するメールアドレス。有効なメールアドレス形式である必要があります。
- `turnstile` （文字列）: Turnstile 検証トークン。ボット攻撃を防ぐために使用されます。

### パスワードリセットメールの送信

- **API名**：パスワードリセットメールの送信
- **HTTP メソッド**：GET
- **パス**：`/api/reset_password`
- **認証要件**：公開 （レート制限あり）
- **機能概要**：登録済みのメールアドレスにパスワードリセットリンクを送信します。ユーザーがパスワードを回復するために使用されます。

💡 リクエスト例：

```
const response = await fetch(`/api/reset_password?email=${email}&turnstile=${turnstileToken}`, {  
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
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "该邮箱地址未注册"  
}
```

🧾 フィールド説明：

- `email` （文字列）: パスワードリセットが必要なメールアドレス。登録済みのメールアドレスである必要があります。
- `turnstile` （文字列）: Turnstile 検証トークン。悪意のあるリクエストを防ぐために使用されます。

### パスワードリセット要求の送信

- **API名**：パスワードリセット要求の送信
- **HTTP メソッド**：POST
- **パス**：`/api/user/reset`
- **認証要件**：公開
- **機能概要**：メール内のリセットリンクを通じてパスワードリセットを完了します。システムが新しいパスワードを生成して返します。

💡 リクエスト例：

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

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": "newPassword123"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "重置链接非法或已过期"  
}
```

🧾 フィールド説明：

- `email` （文字列）: パスワードをリセットするメールアドレス
- `token` （文字列）: リセットメールから取得した検証トークン
- `data` （文字列）: 成功時に返される新しいパスワード。システムが12桁のランダムなパスワードを自動生成します。