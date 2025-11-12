# Midjourney タスクモジュール

!!! info "機能説明"
    APIプレフィックスは http(s)://`<your-domain>` に統一されています

    本番環境では認証トークンを保護するためにHTTPSを使用する必要があります。HTTPは開発環境でのみ推奨されます。

    画像生成タスクの管理システムです。タスクステータスの追跡、進捗監視、結果の確認などの機能をサポートしています。画像URLの転送およびバックグラウンドポーリング更新メカニズムを含みます。

## 🔐 ユーザー認証

### 自身のMJタスクの取得

- **API名**：自身のMJタスクの取得
- **HTTPメソッド**：GET
- **パス**：`/api/mj/self`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーのMidjourneyタスクリストをページネーションで取得します。タスクIDおよび時間範囲によるフィルタリングをサポートしています

💡 リクエスト例：

```
const response = await fetch('/api/mj/self?p=1&page_size=20&mj_id=task123&start_timestamp=1640908800&end_timestamp=1640995200', {  
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
        "mj_id": "task123456",  
        "action": "IMAGINE",  
        "prompt": "a beautiful landscape",  
        "prompt_en": "a beautiful landscape",  
        "status": "SUCCESS",  
        "progress": "100%",  
        "image_url": "https://example.com/image.jpg",  
        "video_url": "https://example.com/video.mp4",  
        "video_urls": "[\"https://example.com/video1.mp4\"]",  
        "submit_time": 1640908800,  
        "start_time": 1640909000,  
        "finish_time": 1640909200,  
        "fail_reason": "",  
        "quota": 1000  
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
  "message": "获取任务列表失败"  
}
```

🧾 フィールド説明：

- `p` （数値）: ページ番号、デフォルトは 1
- `page_size` （数値）: 1ページあたりの数量、デフォルトは 20
- `mj_id` （文字列）: タスクIDによるフィルタリング、オプション 
- `start_timestamp` （数値）: 開始タイムスタンプ、オプション
- `end_timestamp` （数値）: 終了タイムスタンプ、オプション
- 返却フィールド説明：

    - `id` （数値）: データベースレコードID
    - `mj_id` （文字列）: Midjourneyタスクの一意な識別子 
    - `action` （文字列）: 操作タイプ（例：IMAGINE、UPSCALEなど） 
    - `prompt` （文字列）: 元のプロンプト
    - `prompt_en` （文字列）: 英語のプロンプト
    - `status` （文字列）: タスクステータス midjourney.go：19
    - `progress` （文字列）: 完了進捗率（パーセンテージ） 
    - `image_url` （文字列）: 生成された画像URL
    - `video_url` （文字列）: 生成された動画URL
    - `video_urls` （文字列）: 複数の動画URLのJSON配列文字列 
    - `submit_time` （数値）: 送信タイムスタンプ
    - `start_time` （数値）: 処理開始タイムスタンプ
    - `finish_time` （数値）: 完了タイムスタンプ
    - `fail_reason` （文字列）: 失敗理由
    - `quota` （数値）: 消費されたクォータ

## 🔐 管理者認証

### 全てのMJタスクの取得

- **API名**：全てのMJタスクの取得
- **HTTPメソッド**：GET
- **パス**：`/api/mj/`
- **認証要件**：管理者
- **機能概要**：システム内の全てのMidjourneyタスクをページネーションで取得します。チャネルID、タスクID、および時間範囲によるフィルタリングをサポートしています

💡 リクエスト例：

```
const response = await fetch('/api/mj/?p=1&page_size=20&channel_id=1&mj_id=task123&start_timestamp=1640908800&end_timestamp=1640995200', {  
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
        "mj_id": "task123456",  
        "action": "IMAGINE",  
        "prompt": "a beautiful landscape",  
        "status": "SUCCESS",  
        "progress": "100%",  
        "image_url": "https://example.com/image.jpg",  
        "channel_id": 1,  
        "quota": 1000,  
        "submit_time": 1640908800,  
        "finish_time": 1640909200  
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
  "message": "获取任务列表失败"  
}
```

🧾 フィールド説明：

- `p` （数値）: ページ番号、デフォルトは 1
- `page_size` （数値）: 1ページあたりの数量、デフォルトは 20
- `channel_id` （文字列）: チャネルIDによるフィルタリング、オプション 
- `mj_id` （文字列）: タスクIDによるフィルタリング、オプション
- `start_timestamp` （文字列）: 開始タイムスタンプ、オプション
- `end_timestamp` （文字列）: 終了タイムスタンプ、オプション
- 返却されるフィールドには、ユーザー自身のタスクの全てのフィールドに加え、以下が追加されます：

    - `user_id` （数値）: タスクが属するユーザーID 
    - `channel_id` （数値）: 使用されたチャネルID