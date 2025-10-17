# タスクセンターモジュール

!!! info "機能説明"
    インターフェースプレフィックスは、http(s)://`<your-domain>` に統一されています。

    本番環境では、認証トークンを保証するために HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    汎用非同期タスク管理システムです。Suno などのプラットフォームの音楽生成タスクを主にサポートします。タスクステータスの自動更新、失敗時のリトライ、クォータの返却などのメカニズムが含まれます。

## 🔐 ユーザー認証

### 自分のタスクを取得

- **インターフェース名**：自分のタスクを取得
- **HTTP メソッド**：GET
- **パス**：`/api/task/self`
- **認証要件**：ユーザー
- **機能概要**：ページネーションで現在のユーザーのタスクリストを取得します。プラットフォーム、タスク ID、ステータスなどの条件によるフィルタリングをサポートします。

💡 リクエスト例：

```
const response = await fetch('/api/task/self?p=1&page_size=20&platform=suno&task_id=task123&status=SUCCESS&action=song&start_timestamp=1640908800&end_timestamp=1640995200', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
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
        "created_at": 1640908800,  
        "updated_at": 1640909000,  
        "task_id": "task123456",  
        "platform": "suno",  
        "user_id": 1,  
        "quota": 1000,  
        "action": "song",  
        "status": "SUCCESS",  
        "fail_reason": "",  
        "submit_time": 1640908800,  
        "start_time": 1640908900,  
        "finish_time": 1640909000,  
        "progress": "100%",  
        "properties": {},  
        "data": {}  
      }  
    ],  
    "total": 25,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取任务列表失败"  
}
```

🧾 フィールド説明（リクエストパラメータ）：

- `p` （数値）: ページ番号、デフォルトは 1
- `page_size` （数値）: 1ページあたりの件数、デフォルトは 20
- `platform` （文字列）: タスクプラットフォーム、オプション 
- `task_id` （文字列）: タスク ID によるフィルタリング、オプション 
- `status` （文字列）: タスクステータスによるフィルタリング、オプション値："NOT_START"、"SUBMITTED"、"QUEUED"、"IN_PROGRESS"、"FAILURE"、"SUCCESS"、"UNKNOWN" 
- `action` （文字列）: タスクタイプによるフィルタリング、例："song"、"lyrics"など 
- `start_timestamp` （数値）: 開始タイムスタンプ、オプション
- `end_timestamp` （数値）: 終了タイムスタンプ、オプション

🧾 返却フィールド説明：

- `id` （数値）: データベースレコード ID 
- `task_id` （文字列）: サードパーティタスク ID
- `platform` （文字列）: タスクプラットフォーム
- `user_id` （数値）: ユーザー ID
- `quota` （数値）: 消費されたクォータ 
- `action` （文字列）: タスクタイプ
- `status` （文字列）: タスクステータス
- `fail_reason` （文字列）: 失敗理由 
- `submit_time` （数値）: 送信タイムスタンプ
- `start_time` （数値）: 開始タイムスタンプ
- `finish_time` （数値）: 完了タイムスタンプ
- `progress` （文字列）: 進捗率 (パーセンテージ) 
- `properties` （オブジェクト）: タスクプロパティ 
- `data` （オブジェクト）: タスク結果データ 
- `total` （数値）: 条件に一致するタスクの総レコード数
- `page` （数値）: 現在返却されているページ番号
- `page_size` （数値）: 1ページに表示されるタスクレコード数

## 🔐 管理者認証

### 全てのタスクを取得

- **インターフェース名**：全てのタスクを取得
- **HTTP メソッド**：GET
- **パス**：`/api/task/`
- **認証要件**：管理者
- **機能概要**：ページネーションでシステム内の全てのタスクを取得します。チャネル ID、プラットフォーム、ユーザー ID などの条件によるフィルタリングをサポートします。

💡 リクエスト例：

```
const response = await fetch('/api/task/?p=1&page_size=20&channel_id=1&platform=suno&task_id=task123&status=SUCCESS&action=song&start_timestamp=1640908800&end_timestamp=1640995200', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
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
        "created_at": 1640908800,  
        "task_id": "task123456",  
        "platform": "suno",  
        "user_id": 1,  
        "channel_id": 1,  
        "quota": 1000,  
        "action": "song",  
        "status": "SUCCESS",  
        "submit_time": 1640908800,  
        "finish_time": 1640909000,  
        "progress": "100%",  
        "data": {}  
      }  
    ],  
    "total": 100,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取任务列表失败"  
}
```

🧾 フィールド説明（リクエストパラメータ）：

- `p` （数値）: ページ番号、デフォルトは 1
- `page_size` （数値）: 1ページあたりの件数、デフォルトは 20
- `channel_id` （文字列）: チャネル ID フィルタリング、オプション 
- `platform` （文字列）: タスクプラットフォームフィルタリング、オプション
- `task_id` （文字列）: タスク ID フィルタリング、オプション
- `status` （文字列）: タスクステータスフィルタリング、オプション
- `action` （文字列）: タスクタイプフィルタリング、オプション
- `start_timestamp` （数値）: 開始タイムスタンプ、オプション
- `end_timestamp` （数値）: 終了タイムスタンプ、オプション
- 返却フィールドには、ユーザータスクの全てのフィールドが含まれ、さらに以下が追加されます：

    - `channel_id` （数値）: 使用されたチャネル ID