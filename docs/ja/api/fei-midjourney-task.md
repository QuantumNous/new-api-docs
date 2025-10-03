## コア概念 (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス資格情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類、価格倍率に影響 | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# Midjourney タスクモジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています。

    本番環境では認証トークンを保護するために HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    画像生成タスクの管理システムです。タスクステータスの追跡、進捗監視、結果の確認などの機能をサポートしています。画像 URL の転送およびバックグラウンドポーリング更新メカニズムが含まれます。

## 🔐 ユーザー認証

### 自身の MJ タスクの取得

- **インターフェース名**：自身の MJ タスクの取得
- **HTTP 方法**：GET
- **パス**：`/api/mj/self`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーの Midjourney タスクリストをページングで取得します。タスク ID および時間範囲によるフィルタリングをサポートします。

💡 リクエスト例：

```
const response = await fetch('/api/mj/self?p=1&page_size=20&mj_id=task123&start_timestamp=1640908800&end_timestamp=1640995200', {  
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

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "タスクリストの取得に失敗しました"  
}
```

🧾 フィールド説明：

- `p` （数字）: ページ番号、デフォルトは 1
- `page_size` （数字）: 1ページあたりの数量、デフォルトは 20
- `mj_id` （文字列）: タスク ID フィルタリング、オプション 
- `start_timestamp` （数字）: 開始タイムスタンプ、オプション
- `end_timestamp` （数字）: 終了タイムスタンプ、オプション
- 返却フィールドの説明：

    - `id` （数字）: データベースレコード ID
    - `mj_id` （文字列）: Midjourney タスクの一意の識別子 
    - `action` （文字列）: 操作タイプ。例: IMAGINE、UPSCALE など 
    - `prompt` （文字列）: 元のプロンプト
    - `prompt_en` （文字列）: 英語のプロンプト
    - `status` （文字列）: タスクステータス midjourney.go：19
    - `progress` （文字列）: 完了進捗のパーセンテージ 
    - `image_url` （文字列）: 生成された画像 URL
    - `video_url` （文字列）: 生成された動画 URL
    - `video_urls` （文字列）: 複数の動画 URL の JSON 配列文字列 
    - `submit_time` （数字）: 提出タイムスタンプ
    - `start_time` （数字）: 処理開始タイムスタンプ
    - `finish_time` （数字）: 完了タイムスタンプ
    - `fail_reason` （文字列）: 失敗理由
    - `quota` （数字）: 消費されたクォータ

## 🔐 管理者認証

### 全ての MJ タスクの取得

- **インターフェース名**：全ての MJ タスクの取得
- **HTTP 方法**：GET
- **パス**：`/api/mj/`
- **認証要件**：管理者
- **機能概要**：システム内の全ての Midjourney タスクをページングで取得します。チャネル ID、タスク ID、および時間範囲によるフィルタリングをサポートします。

💡 リクエスト例：

```
const response = await fetch('/api/mj/?p=1&page_size=20&channel_id=1&mj_id=task123&start_timestamp=1640908800&end_timestamp=1640995200', {  
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

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "タスクリストの取得に失敗しました"  
}
```

🧾 フィールド説明：

- `p` （数字）: ページ番号、デフォルトは 1
- `page_size` （数字）: 1ページあたりの数量、デフォルトは 20
- `channel_id` （文字列）: チャネル ID フィルタリング、オプション 
- `mj_id` （文字列）: タスク ID フィルタリング、オプション
- `start_timestamp` （文字列）: 開始タイムスタンプ、オプション
- `end_timestamp` （文字列）: 終了タイムスタンプ、オプション
- 返却フィールドには、ユーザー自身のタスクの全てのフィールドが含まれ、さらに以下が追加されます：

    - `user_id` （数字）: タスクに属するユーザー ID 
    - `channel_id` （数字）: 使用されたチャネル ID