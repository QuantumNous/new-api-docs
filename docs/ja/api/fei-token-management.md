## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| レート | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス資格情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格レートに影響します | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス割り当て量 | Available service quota for users |

# トークン管理モジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています

    本番環境では認証トークンを保護するために HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    ユーザー API Token の完全な管理システムです。トークンの作成、更新、削除、一括操作などの機能をサポートしています。モデル制限、IP制限、クォータ管理、有効期限などの詳細な制御が含まれます。フロントエンドのトークンページのコアデータソースです。

## 🔐 ユーザー認証

### 全トークンの取得

- **インターフェース名**：全トークンの取得
- **HTTP メソッド**：GET
- **パス**：`/api/token/`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーのすべてのトークンリストをページネーションで取得します

💡 リクエスト例：

```
const response = await fetch('/api/token/?p=1&size=20', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "name": "API Token",  
        "key": "<YOUR_API_KEY>",  
        "status": 1,  
        "remain_quota": 1000000,  
        "unlimited_quota": false,  
        "expired_time": 1640995200,  
        "created_time": 1640908800,  
        "accessed_time": 1640995000  
      }  
    ],  
    "total": 5,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "トークンリストの取得に失敗しました"  
}
```

🧾 フィールド説明：

- `p` （数値）: ページ番号。デフォルトは 1
- `size` （数値）: 1ページあたりの件数。デフォルトは 20
- `items` （配列）: トークン情報リスト
- `total` （数値）: トークンの総数
- `page` （数値）: 現在のページ番号
- `page_size` （数値）: 1ページあたりの件数

### トークンの検索

- **インターフェース名**：トークンの検索
- **HTTP メソッド**：GET
- **パス**：`/api/token/search`
- **認証要件**：ユーザー
- **機能概要**：キーワードとトークン値に基づいてユーザーのトークンを検索します

💡 リクエスト例：

```
const response = await fetch('/api/token/search?keyword=api&token=sk-123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    {  
      "id": 1,  
      "name": "API Token",  
      "key": "sk-your-token-placeholder",  
      "status": 1,  
      "remain_quota": 1000000  
    }  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "トークンの検索に失敗しました"  
}
```

🧾 フィールド説明：

- `keyword` （文字列）: 検索キーワード。トークン名に一致します
- `token` （文字列）: トークン値による検索。部分一致をサポートします

### 個別トークンの取得

- **インターフェース名**：個別トークンの取得
- **HTTP メソッド**：GET
- **パス**：`/api/token/:id`
- **認証要件**：ユーザー
- **機能概要**：指定されたトークンの詳細情報を取得します

💡 リクエスト例：

```
const response = await fetch('/api/token/123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "id": 123,  
    "name": "API Token",  
    "key": "sk-your-token-placeholder",  
    "status": 1,  
    "remain_quota": 1000000,  
    "unlimited_quota": false,  
    "model_limits_enabled": true,  
    "model_limits": "gpt-3.5-turbo,gpt-4",  
    "allow_ips": "192.168.1.1,10.0.0.1",  
    "group": "default",  
    "expired_time": 1640995200,  
    "created_time": 1640908800,  
    "accessed_time": 1640995000  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "Tokenが存在しません"  
}
```

🧾 フィールド説明：

`id` （数値）: トークン ID。URL パス経由で渡されます

### トークンの作成

- **インターフェース名**：トークンの作成
- **HTTP メソッド**：POST
- **パス**：`/api/token/`
- **認証要件**：ユーザー
- **機能概要**：新しい API Token を作成します。一括作成をサポートします

💡 リクエスト例：

```
const response = await fetch('/api/token/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    name: "My API Token",  
    expired_time: 1640995200,  
    remain_quota: 1000000,  
    unlimited_quota: false,  
    model_limits_enabled: true,  
    model_limits: ["gpt-3.5-turbo", "gpt-4"],  
    allow_ips: "192.168.1.1,10.0.0.1",  
    group: "default"  
  })  
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
  "message": "トークン名が長すぎます"  
}
```

🧾 フィールド説明：

- `name` （文字列）: トークン名。最大長 30 文字
- `expired_time` （数値）: 有効期限のタイムスタンプ。-1 は無期限を示します
- `remain_quota` （数値）: 残りクォータ
- `unlimited_quota` （ブール型）: 無制限クォータであるかどうか
- `model_limits_enabled` （ブール型）: モデル制限を有効にするかどうか
- `model_limits` （配列）: 使用を許可するモデルのリスト
- `allow_ips` （文字列）: 許可された IP アドレス。コンマ区切り
- `group` （文字列）: 所属グループ

### トークンの更新

- **インターフェース名**：トークンの更新
- **HTTP メソッド**：PUT
- **パス**：`/api/token/`
- **認証要件**：ユーザー
- **機能概要**：トークン設定を更新します。ステータスの切り替えと完全な更新をサポートします

💡 リクエスト例（完全更新）：

```
const response = await fetch('/api/token/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    name: "Updated Token",  
    expired_time: 1640995200,  
    remain_quota: 2000000,  
    unlimited_quota: false,  
    model_limits_enabled: true,  
    model_limits: ["gpt-3.5-turbo", "gpt-4"],  
    allow_ips: "192.168.1.1",  
    group: "vip"  
  })  
});  
const data = await response.json();
```

💡 リクエスト例（ステータスのみ更新）：

```
const response = await fetch('/api/token/?status_only=true', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    status: 1  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "id": 123,  
    "name": "Updated Token",  
    "status": 1  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "トークンは期限切れのため有効化できません。先にトークンの有効期限を変更するか、無期限に設定してください"  
}
```

🧾 フィールド説明：

- `id` （数値）: トークン ID。必須
- `status_only` （クエリパラメータ）: ステータスのみを更新するかどうか
- その他のフィールドはトークン作成インターフェースと同じで、すべてオプションです

### トークンの削除

- **インターフェース名**：トークンの削除
- **HTTP メソッド**：DELETE
- **パス**：`/api/token/:id`
- **認証要件**：ユーザー
- **機能概要**：指定されたトークンを削除します

💡 リクエスト例：

```
const response = await fetch('/api/token/123', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
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
  "message": "Tokenが存在しません"  
}
```

🧾 フィールド説明：

`id` （数値）: トークン ID。URL パス経由で渡されます

### トークンの一括削除

- **インターフェース名**：トークンの一括削除
- **HTTP メソッド**：POST
- **パス**：`/api/token/batch`
- **認証要件**：ユーザー
- **機能概要**：複数のトークンを一括で削除します

💡 リクエスト例：

```
const response = await fetch('/api/token/batch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token'  
  },  
  body: JSON.stringify({  
    ids: [1, 2, 3, 4, 5]  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": 5  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "パラメータエラー"  
}
```

🧾 フィールド説明：

- `ids` （配列）: 削除するトークン ID のリスト。必須であり、空であってはなりません
- `data` （数値）: 正常に削除されたトークンの数