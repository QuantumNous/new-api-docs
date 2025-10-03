## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響する | Classification of users or tokens, affecting price ratios |
| 割当枠 | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# アカウント請求ダッシュボードモジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています

    本番環境では認証トークンを保護するために HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    OpenAI SDK 互換の請求照会インターフェース。トークン認証を使用し、サブスクリプション情報と使用量照会を提供します。主にサードパーティアプリケーションおよび SDK 統合に使用され、OpenAI API との完全な互換性を保証します。

## 🔐 ユーザー認証

### サブスクリプション枠情報の取得

- **インターフェース名**：サブスクリプション枠情報の取得
- **HTTP メソッド**：GET
- **パス**：`/dashboard/billing/subscription`
- **認証要件**：ユーザー Token
- **機能概要**：ユーザーのサブスクリプション割当情報（総枠、ハードリミット、アクセス有効期限を含む）を取得します。OpenAI API 形式と互換性があります。

💡 リクエスト例：

```
const response = await fetch('/dashboard/billing/subscription', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "object": "billing_subscription",  
  "has_payment_method": true,  
  "soft_limit_usd": 100.0,  
  "hard_limit_usd": 100.0,  
  "system_hard_limit_usd": 100.0,  
  "access_until": 1640995200  
}
```

❗ 失敗応答例：

```
{  
  "error": {  
    "message": "获取配额失败",  
    "type": "upstream_error"  
  }  
}
```

🧾 フィールド説明：

- `object` （文字列）: 固定値 "billing_subscription"
- `has_payment_method` （ブール型）: 支払い方法があるかどうか。固定で true
- `soft_limit_usd` （数値）: ソフトリミット枠（米ドル）
- `hard_limit_usd` （数値）: ハードリミット枠（米ドル）
- `system_hard_limit_usd` （数値）: システムハードリミット枠（米ドル）
- `access_until` （数値）: アクセス有効期限タイムスタンプ、Token の有効期限

### OpenAI SDK 互換パス - サブスクリプション枠情報の取得

- **インターフェース名**：OpenAI SDK 互換パス - サブスクリプション枠情報の取得
- **HTTP メソッド**：GET
- **パス**：`/v1/dashboard/billing/subscription`
- **認証要件**：ユーザー Token
- **機能概要**：上記のインターフェースと機能は完全に同じであり、OpenAI SDK 互換パスを提供します。

💡 リクエスト例：

```
const response = await fetch('/v1/dashboard/billing/subscription', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "object": "billing_subscription",  
  "has_payment_method": true,  
  "soft_limit_usd": 100.0,  
  "hard_limit_usd": 100.0,  
  "system_hard_limit_usd": 100.0,  
  "access_until": 1640995200  
}
```

❗ 失敗応答例：

```
{  
  "error": {  
    "message": "获取配额失败",  
    "type": "upstream_error"  
  }  
}
```

🧾 フィールド説明：

- `object` （文字列）: 固定値 "billing_subscription"
- `has_payment_method` （ブール型）: 支払い方法があるかどうか。固定で true
- `soft_limit_usd` （数値）: ソフトリミット枠（米ドル）
- `hard_limit_usd` （数値）: ハードリミット枠（米ドル）
- `system_hard_limit_usd` （数値）: システムハードリミット枠（米ドル）
- `access_until` （数値）: アクセス有効期限タイムスタンプ、Token の有効期限

### 使用量情報の取得

- **インターフェース名**：使用量情報の取得
- **HTTP メソッド**：GET
- **パス**：`/dashboard/billing/usage`
- **認証要件**：ユーザー Token
- **機能概要**：ユーザーの割当使用量情報を取得します。OpenAI API 形式と互換性があります。

💡 リクエスト例：

```
const response = await fetch('/dashboard/billing/usage', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "object": "list",  
  "total_usage": 2500.0  
}
```

❗ 失敗応答例：

```
{  
  "error": {  
    "message": "获取使用量失败",  
    "type": "new_api_error"  
  }  
}
```

🧾 フィールド説明：

- `object` （文字列）: 固定値 "list"
- `total_usage` （数値）: 総使用量。単位は 0.01 米ドル

### OpenAI SDK 互換パス - 使用量情報の取得

- **インターフェース名**：OpenAI SDK 互換パス - 使用量情報の取得
- **HTTP メソッド**：GET
- **パス**：`/v1/dashboard/billing/usage`
- **認証要件**：ユーザー Token
- **機能概要**：上記のインターフェースと機能は完全に同じであり、OpenAI SDK 互換パスを提供します。

💡 リクエスト例：

```
const response = await fetch('/v1/dashboard/billing/usage', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "object": "list",  
  "total_usage": 2500.0  
}
```

❗ 失敗応答例：

```
{  
  "error": {  
    "message": "获取使用量失败",  
    "type": "new_api_error"  
  }  
}
```

🧾 フィールド説明：

- `object` （文字列）: 固定値 "list"
- `total_usage` （数値）: 総使用量。単位は 0.01 米ドル