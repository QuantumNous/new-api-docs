# システム初期化モジュール

!!! info "機能説明"
    機能インターフェースのプレフィックスは、http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境ではHTTPSを使用する必要があります。HTTPは開発環境でのみ推奨されます。

    システム初期化モジュールは、初回デプロイ設定と稼働状況の監視を担当します。SQLite、MySQL、PostgreSQLデータベースをサポートし、Rootユーザーの作成とシステムパラメータの初期化を含みます。ステータスインターフェースは、OAuth設定、機能スイッチなどを含むリアルタイムのシステム情報を提供します。

## 🔐 認証不要

### システム初期化ステータスの取得

- **インターフェース名**：システム初期化ステータスの取得
- **HTTP メソッド**：GET
- **パス**：`/api/setup`
- **認証要件**：公開
- **機能概要**：システムが初期化を完了しているかを確認し、データベースタイプと Rootユーザーのステータスを取得します。

💡 リクエスト例：

```
const response = await fetch('/api/setup', {  
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
  "data": {  
    "status": false,  
    "root_init": true,  
    "database_type": "sqlite"  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "系统错误"  
}
```

🧾 フィールド説明：

- `status`（ブール型）: システムが初期化を完了しているかどうか
- `root_init`（ブール型）: Rootユーザーが既に存在するかどうか
- `database_type`（文字列）: データベースタイプ。選択可能な値："mysql"、"postgres"、"sqlite"

### 初回インストールウィザードの完了

- **インターフェース名**：初回インストールウィザードの完了
- **HTTP メソッド**：POST
- **パス**：`/api/setup`
- **認証要件**：公開
- **機能概要**：Root管理者アカウントを作成し、システム初期化設定を完了します。

💡 リクエスト例：

```
const response = await fetch('/api/setup', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json'  
  },  
  body: JSON.stringify({  
    username: "admin",  
    password: "password123",  
    confirmPassword: "password123",  
    SelfUseModeEnabled: false,  
    DemoSiteEnabled: false  
  })  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "系统初始化完成"  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "用户名长度不能超过12个字符"  
}
```

🧾 フィールド説明：

- `username` （文字列）: 管理者ユーザー名、最大長 12文字
- `password` （文字列）: 管理者パスワード、最低 8文字
- `confirmPassword` （文字列）: 確認パスワード。passwordと一致する必要があります
- `SelfUseModeEnabled` （ブール型）: 自己利用モードを有効にするかどうか
- `DemoSiteEnabled` （ブール型）: デモサイトモードを有効にするかどうか

### 稼働状況の概要の取得

- **インターフェース名**：稼働状況の概要の取得
- **HTTP メソッド**：GET
- **パス**：`/api/status`
- **認証要件**：公開
- **機能概要**：システムの稼働状況、設定情報、および機能スイッチの状態を取得します。

💡 リクエスト例：

```
const response = await fetch('/api/status', {  
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
  "data": {  
    "version": "v1.0.0",  
    "start_time": 1640995200,  
    "email_verification": false,  
    "github_oauth": true,  
    "github_client_id": "your_client_id",  
    "system_name": "New API",  
    "quota_per_unit": 500000,  
    "display_in_currency": true,  
    "enable_drawing": true,  
    "enable_task": true,  
    "setup": true  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "获取状态失败"  
}
```

🧾 フィールド説明：

- `version` （文字列）: システムバージョン番号
- `start_time` （数値）: システム起動タイムスタンプ
- `email_verification` （ブール型）: メール認証を有効にするかどうか
- `github_oauth` （ブール型）: GitHub OAuthログインを有効にするかどうか
- `github_client_id` （文字列）: GitHub OAuth クライアントID
- `system_name` （文字列）: システム名
- `quota_per_unit` （数値）: 単位あたりのクォータ数量
- `display_in_currency` （ブール型）: 通貨形式で表示するかどうか
- `enable_drawing` （ブール型）: 描画機能を有効にするかどうか
- `enable_task` （ブール型）: タスク機能を有効にするかどうか
- `setup` （ブール型）: システムが初期化を完了しているかどうか

### Uptime-Kuma互換ステータスプローブ

- **インターフェース名**：Uptime-Kuma 互換ステータスプローブ
- **HTTP メソッド**：GET
- **パス**：`/api/uptime/status`
- **認証要件**：公開
- **機能概要**：Uptime-Kuma監視システムと互換性のあるステータスチェックインターフェースを提供します。

💡 リクエスト例：

```
const response = await fetch('/api/uptime/status', {  
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
  "data": [  
    {  
      "categoryName": "OpenAI服务",  
      "monitors": [  
        {  
          "name": "GPT-4",  
          "group": "OpenAI",  
          "status": 1,  
          "uptime": 99.5  
        }  
      ]  
    }  
  ]  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "获取监控数据失败"  
}
```

🧾 フィールド説明：

- `categoryName` （文字列）: 監視カテゴリ名
- `monitors` （配列）: 監視項目リスト
    - `name` （文字列）: 監視項目名
    - `group` （文字列）: 監視グループ名
    - `status` （数値）: ステータスコード。1=正常、0=異常
    - `uptime` （数値）: 稼働率のパーセンテージ

## 🔐 管理者認証

### バックエンドと依存コンポーネントのテスト

- **インターフェース名**：バックエンドと依存コンポーネントのテスト
- **HTTP メソッド**：GET
- **パス**：`/api/status/test`
- **認証要件**：管理者
- **機能概要**：システムの各コンポーネントの接続状態と健全性をテストします。

💡 リクエスト例：

```
const response = await fetch('/api/status/test', {  
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
  "message": "所有组件测试通过",  
  "data": {  
    "database": "connected",  
    "redis": "connected",  
    "external_apis": "healthy"  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "数据库连接失败"  
}
```

🧾 フィールド説明：

- `database` （文字列）: データベース接続状態
- `redis` （文字列）: Redis 接続状態
- `external_apis` （文字列）: 外部 API の健全性ステータス