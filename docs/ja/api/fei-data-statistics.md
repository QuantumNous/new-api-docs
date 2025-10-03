# データ統計モジュール

!!! info "機能説明"
    APIプレフィックスは http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    使用量データを集計する統計システムです。管理者はサイト全体の統計を、ユーザーは個人の統計を表示できます。データはモデルと日付ごとにグループ化され、グラフやレポートの生成、システムの使用傾向の監視に使用されます。

## 🔐 ユーザー認証

### 日付別マイ使用量統計

- **API名**：日付別マイ使用量統計
- **HTTPメソッド**：GET
- **パス**：`/api/data/self`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーの使用量データを日付別に取得します。期間指定クエリをサポートします。

💡 リクエスト例：

```
const response = await fetch('/api/data/self?start_timestamp=1640908800&end_timestamp=1640995200', {  
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
      "model_name": "gpt-3.5-turbo",  
      "count": 25,  
      "quota": 12500,  
      "token_used": 2000,  
      "created_at": 1640995200,  
      "user_id": 1,  
      "username": "testuser"  
    },  
    {  
      "model_name": "gpt-4",  
      "count": 10,  
      "quota": 30000,  
      "token_used": 1500,  
      "created_at": 1640995200,  
      "user_id": 1,  
      "username": "testuser"  
    }  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取个人统计数据失败"  
}
```

🧾 フィールド説明：

- `start_timestamp` （数値）: 開始タイムスタンプ、オプション
- `end_timestamp` （数値）: 終了タイムスタンプ、オプション
- `data` （配列）: 個人統計データリスト 

    - `model_name` （文字列）: モデル名
    - `count` （数値）: リクエスト回数
    - `quota` （数値）: クォータ消費
    - `token_used` （数値）: トークン使用量
    - `created_at` （数値）: 統計日付タイムスタンプ
    - `user_id` （数値）: ユーザーID
    - `username` （文字列）: ユーザー名

## 🔐 管理者認証

### 日付別サイト全体使用量統計

- **API名**：日付別サイト全体使用量統計
- **HTTPメソッド**：GET
- **パス**：`/api/data/`
- **認証要件**：管理者
- **機能概要**：システム全体の用量データを日付別に取得します。ユーザー名によるフィルタリングと期間指定クエリをサポートします。

💡 リクエスト例：

```
const response = await fetch('/api/data/?start_timestamp=1640908800&end_timestamp=1640995200&username=testuser', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
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
      "model_name": "gpt-3.5-turbo",  
      "count": 150,  
      "quota": 75000,  
      "token_used": 12500,  
      "created_at": 1640995200  
    },  
    {  
      "model_name": "gpt-4",  
      "count": 50,  
      "quota": 150000,  
      "token_used": 8000,  
      "created_at": 1640995200  
    }  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取统计数据失败"  
}
```

🧾 フィールド説明：

- `start_timestamp` （数値）: 開始タイムスタンプ、オプション
- `end_timestamp` （数値）: 終了タイムスタンプ、オプション
- `username` （文字列）: ユーザー名によるフィルタリング、オプション 
- `data` （配列）: 統計データリスト。モデルと日付ごとにグループ化され集計されます。 

    - `model_name` （文字列）: モデル名
    - `count` （数値）: リクエスト回数の合計
    - `quota` （数値）: クォータ消費の合計
    - `token_used` （数値）: トークン使用量の合計
    - `created_at` （数値）: 統計日付タイムスタンプ