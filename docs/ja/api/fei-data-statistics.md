## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| レート | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格レートに影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス許容量 | Available service quota for users |

# データ統計モジュール

!!! info "機能説明"
    APIプレフィックスは http(s)://`<your-domain>` に統一されます。

    本番環境では認証トークンを保護するためにHTTPSを使用する必要があります。HTTPは開発環境でのみ推奨されます。

    使用量データを集計する統計システムです。管理者は全サイトの統計を、ユーザーは個人の統計を確認できます。データはモデルと日付ごとにグループ化され、グラフやレポートの生成、システムの使用傾向の監視に使用されます。

## 🔐 ユーザー認証

### 私の使用量を日付別に統計

- **インターフェース名**：私の使用量を日付別に統計
- **HTTP メソッド**：GET
- **パス**：`/api/data/self`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーの使用量データを日付別に取得します。時間範囲クエリをサポートします。

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

✅ 成功応答例：

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

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "個人統計データの取得に失敗しました"  
}
```

🧾 フィールド説明：

- `start_timestamp` （数字）: 開始タイムスタンプ、オプション
- `end_timestamp` （数字）: 終了タイムスタンプ、オプション
- `data` （配列）: 個人統計データリスト 

    - `model_name` （文字列）: モデル名
    - `count` （数字）: リクエスト回数
    - `quota` （数字）: クォータ消費量
    - `token_used` （数字）: トークン使用量
    - `created_at` （数字）: 統計日付のタイムスタンプ
    - `user_id` （数字）: ユーザーID
    - `username` （文字列）: ユーザー名

## 🔐 管理者認証

### 全サイトの使用量を日付別に統計

- **インターフェース名**：全サイトの使用量を日付別に統計
- **HTTP メソッド**：GET
- **パス**：`/api/data/`
- **認証要件**：管理者
- **機能概要**：システム全体の用量データを日付別に取得します。ユーザー名によるフィルタリングと時間範囲クエリをサポートします。

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

✅ 成功応答例：

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

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "統計データの取得に失敗しました"  
}
```

🧾 フィールド説明：

- `start_timestamp` （数字）: 開始タイムスタンプ、オプション
- `end_timestamp` （数字）: 終了タイムスタンプ、オプション
- `username` （文字列）: ユーザー名フィルタリング、オプション 
- `data` （配列）: 統計データリスト。モデルと日付ごとにグループ化され集計されます。 

    - `model_name` （文字列）: モデル名
    - `count` （数字）: リクエスト回数の合計
    - `quota` （数字）: クォータ消費量の合計
    - `token_used` （数字）: トークン使用量の合計
    - `created_at` （数字）: 統計日付のタイムスタンプ