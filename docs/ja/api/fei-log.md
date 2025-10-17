# ログモジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています

    本番環境では認証トークンを保護するために HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    階層化されたログクエリシステムは、管理者が全サイトのログを表示し、ユーザーが個人のログを表示することをサポートします。リアルタイム統計（RPM/TPM）、多次元フィルタリング、履歴データクリーンアップなどの機能を提供します。CORSをサポートするトークンクエリインターフェースは、サードパーティ統合を容易にします。

## 🔐 認証不要

### トークンによるログ検索

- **インターフェース名**：トークンによるログ検索
- **HTTP メソッド**：GET
- **パス**：`/api/log/token`
- **認証要件**：公開
- **機能概要**：トークンキーを使用して関連するログ記録を検索します。クロスオリジンアクセス（CORS）をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/log/token?key=<TOKEN_PLACEHOLDER>', {  
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
  "data": [  
    {  
      "id": 1,  
      "type": 2,  
      "content": "API调用成功",  
      "model_name": "gpt-4",  
      "quota": 1000,  
      "created_at": 1640995000  
    }  
  ]  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "Token不存在或无权限"  
}
```

🧾 フィールド説明：

`key` （文字列）: トークンキー。必須。

## 🔐 ユーザー認証

### マイログ統計

- **インターフェース名**：マイログ統計
- **HTTP メソッド**：GET
- **パス**：`/api/log/self/stat`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーのログ統計情報（クォータ消費、リクエスト頻度、トークン使用量を含む）を取得します。

💡 リクエスト例：

```
const response = await fetch('/api/log/self/stat?type=2&start_timestamp=1640908800&end_timestamp=1640995200&token_name=api_token&model_name=gpt-4&group=default', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "quota": 50000,  
    "rpm": 10,  
    "tpm": 1500  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "获取统计信息失败"  
}
```

🧾 フィールド説明：

- `type` （数字）: ログタイプ。オプション値：1=チャージ、2=消費、3=管理、4=エラー、5=システム
- `start_timestamp` （数字）: 開始タイムスタンプ
- `end_timestamp` （数字）: 終了タイムスタンプ
- `token_name` （文字列）: トークン名によるフィルタリング
- `model_name` （文字列）: モデル名によるフィルタリング
- `group` （文字列）: グループによるフィルタリング
- `quota` （数字）: 指定された時間範囲内の総クォータ消費量
- `rpm` （数字）: 1分あたりのリクエスト数（直近60秒）
- `tpm` （数字）: 1分あたりのトークン数（直近60秒）

### マイログの取得

- **インターフェース名**：マイログの取得
- **HTTP メソッド**：GET
- **パス**：`/api/log/self`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーのログ記録をページネーションで取得します。複数のフィルタリング条件をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/log/self?p=1&page_size=20&type=2&start_timestamp=1640908800&end_timestamp=1640995200&token_name=api_token&model_name=gpt-4&group=default', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "user_id": 1,  
        "created_at": 1640995000,  
        "type": 2,  
        "content": "API调用成功",  
        "token_name": "api_token",  
        "model_name": "gpt-4",  
        "quota": 1000,  
        "prompt_tokens": 50,  
        "completion_tokens": 100  
      }  
    ],  
    "total": 25,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "获取日志失败"  
}
```

🧾 フィールド説明：

リクエストパラメータは全ログ取得インターフェースと同じですが、現在のユーザーのログ記録のみを返します

### マイログの検索

- **インターフェース名**：マイログの検索
- **HTTP メソッド**：GET
- **パス**：`/api/log/self/search`
- **認証要件**：ユーザー
- **機能概要**：キーワードに基づいて現在のユーザーのログ記録を検索します。

💡 リクエスト例：

```
const response = await fetch('/api/log/self/search?keyword=gpt-4', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    {  
      "id": 1,  
      "type": 2,  
      "content": "GPT-4调用成功",  
      "model_name": "gpt-4",  
      "created_at": 1640995000  
    }  
  ]  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "搜索日志失败"  
}
```

🧾 フィールド説明：

`keyword` （文字列）: 検索キーワード。現在のユーザーのログタイプに一致します。

## 🔐 管理者認証

### 全ログの取得

- **インターフェース名**：全ログの取得
- **HTTP メソッド**：GET
- **パス**：`/api/log/`
- **認証要件**：管理者
- **機能概要**：システム内のすべてのログ記録をページネーションで取得します。複数のフィルタリング条件とログタイプによる絞り込みをサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/log/?p=1&page_size=20&type=2&start_timestamp=1640908800&end_timestamp=1640995200&username=testuser&token_name=api_token&model_name=gpt-4&channel=1&group=default', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "user_id": 1,  
        "created_at": 1640995000,  
        "type": 2,  
        "content": "API调用成功",  
        "username": "testuser",  
        "token_name": "api_token",  
        "model_name": "gpt-4",  
        "quota": 1000,  
        "prompt_tokens": 50,  
        "completion_tokens": 100,  
        "use_time": 2,  
        "is_stream": false,  
        "channel_id": 1,  
        "channel_name": "OpenAI渠道",  
        "token_id": 1,  
        "group": "default",  
        "ip": "192.168.1.1",  
        "other": "{\"model_ratio\":15.0}"  
      }  
    ],  
    "total": 100,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "获取日志失败"  
}
```

🧾 フィールド説明：

- `p` （数字）: ページ番号。デフォルトは 1。
- `page_size` （数字）: 1ページあたりの件数。デフォルトは 20。
- `type` （数字）: ログタイプ。オプション値：1=チャージ、2=消費、3=管理、4=エラー、5=システム log.go：41-48
- `start_timestamp` （数字）: 開始タイムスタンプ
- `end_timestamp` （数字）: 終了タイムスタンプ
- `username` （文字列）: ユーザー名によるフィルタリング
- `token_name` （文字列）: トークン名によるフィルタリング
- `model_name` （文字列）: モデル名によるフィルタリング
- `channel` （数字）: チャネル ID によるフィルタリング
- `group` （文字列）: グループによるフィルタリング

### 履歴ログの削除

- **インターフェース名**：履歴ログの削除
- **HTTP メソッド**：DELETE
- **パス**：`/api/log/`
- **認証要件**：管理者
- **機能概要**：指定されたタイムスタンプ以前の履歴ログ記録を一括削除します。データベースの負荷が高くなるのを避けるため、バッチ削除をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/log/?target_timestamp=1640908800', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": 1500  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "target timestamp is required"  
}
```

🧾 フィールド説明：

- `target_timestamp` （数字）: ターゲットタイムスタンプ。この時間以前のすべてのログを削除します。必須。
- `data` （数字）: 正常に削除されたログの条数

### ログ統計

- **インターフェース名**：ログ統計
- **HTTP メソッド**：GET
- **パス**：`/api/log/stat`
- **認証要件**：管理者
- **機能概要**：指定された時間範囲と条件に基づいたログ統計情報（クォータ消費、リクエスト頻度、トークン使用量を含む）を取得します。

💡 リクエスト例：

```
const response = await fetch('/api/log/stat?type=2&start_timestamp=1640908800&end_timestamp=1640995200&username=testuser&token_name=api_token&model_name=gpt-4&channel=1&group=default', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id' 
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "quota": 150000,  
    "rpm": 25,  
    "tpm": 3500  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "获取统计信息失败"  
}
```

🧾 フィールド説明：

- リクエストパラメータは全ログ取得インターフェースと同じです
- `quota` （数字）: 指定された時間範囲内の総クォータ消費量
- `rpm` （数字）: 1分あたりのリクエスト数（直近60秒） log.go：357
- `tpm` （数字）: 1分あたりのトークン数（直近60秒の prompt_tokens + completion_tokens の合計）

### 全ログの検索

- **インターフェース名**：全ログの検索
- **HTTP メソッド**：GET
- **パス**：`/api/log/search`
- **認証要件**：管理者
- **機能概要**：キーワードに基づいてシステム内のすべてのログ記録を検索します。

💡 リクエスト例：

```
const response = await fetch('/api/log/search?keyword=error', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    {  
      "id": 1,  
      "type": 4,  
      "content": "API调用错误",  
      "username": "testuser",  
      "created_at": 1640995000  
    }  
  ]  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "搜索日志失败"  
}
```

🧾 フィールド説明：

`keyword` （文字列）: 検索キーワード。ログタイプまたは内容に一致させることができます。