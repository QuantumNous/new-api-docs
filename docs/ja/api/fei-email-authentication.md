## コア概念 (Core Concepts)

| 中文 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | APIアクセス資格情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| 渠道 | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| 分组 | Group | ユーザーまたはトークンの分類。価格レートに影響を与える | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | ユーザーが利用可能なサービス割り当て量 | Available service quota for users |

# メール認証モジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    メール認証およびパスワードリセット機能を実装し、レート制限と Turnstile 保護を統合しています。ランダムなパスワードの自動生成とメールテンプレートのカスタマイズに対応しています。ユーザー登録、アカウント連携などのシナリオで広く使用されます。

## 🔐 認証不要

### メール認証メールの送信

- **インターフェース名**：メール認証メールの送信
- **HTTP メソッド**：GET
- **パス**：`/api/verification`
- **認証要件**：公開 （レート制限あり）
- **機能概要**：指定されたメールアドレスにメール認証コードを送信します。メールの連携または認証操作に使用されます。

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
  "message": "無効なパラメーター"  
}
```

🧾 フィールド説明：

- `email` （文字列）: 認証コードを受け取るメールアドレス。有効なメール形式である必要があります。
- `turnstile` （文字列）: Turnstile 認証トークン。ボット攻撃を防ぐために使用されます。

### パスワードリセットメールの送信

- **インターフェース名**：パスワードリセットメールの送信
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
  "message": "このメールアドレスは登録されていません"  
}
```

🧾 フィールド説明：

- `email` （文字列）: パスワードをリセットする必要があるメールアドレス。登録済みのメールアドレスである必要があります。
- `turnstile` （文字列）: Turnstile 認証トークン。悪意のあるリクエストを防ぐために使用されます。

### パスワードリセット要求の送信

- **インターフェース名**：パスワードリセット要求の送信
- **HTTP メソッド**：POST
- **パス**：`/api/user/reset`
- **認証要件**：公開
- **機能概要**：メール内のリセットリンクを通じてパスワードリセットを完了します。システムは新しいパスワードを生成して返します。

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
  "message": "リセットリンクが無効であるか、期限切れです"  
}
```

🧾 フィールド説明：

- `email` （文字列）: パスワードをリセットするメールアドレス。
- `token` （文字列）: リセットメールから取得した認証トークン。
- `data` （文字列）: 成功時に返される新しいパスワード。システムによって12桁のランダムなパスワードが自動生成されます。