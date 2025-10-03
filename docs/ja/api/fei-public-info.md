## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| レート | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格レートに影響する | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# 公開情報モジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています

    本番環境では、認証トークンを保護するために HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    認証不要または低権限でアクセス可能なシステム情報（モデルリスト、価格設定情報、お知らせ内容など）を提供します。多言語表示と動的設定をサポートしています。フロントエンドのホームページやモデル広場は、主にこれらのインターフェースに依存して表示データを取得します。

## 🔐 認証不要

### お知らせ内容の取得

- **インターフェース名**：お知らせ内容の取得
- **HTTP メソッド**：GET
- **パス**：`/api/notice`
- **認証要件**：公開
- **機能概要**：システムのお知らせ内容を取得します。Markdown形式をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/notice', {  
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
  "message": "",  
  "data": "# システム公告\n\n欢迎使用New API系统！"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取公告失败"  
}
```

🧾 フィールド説明：

`data` （文字列）: お知らせ内容。Markdown形式をサポートしています。

### 「このシステムについて」ページ情報

- **インターフェース名**：「このシステムについて」ページ情報
- **HTTP メソッド**：GET
- **パス**：`/api/about`
- **認証要件**：公開
- **機能概要**：「このシステムについて」ページのカスタムコンテンツを取得します。

💡 リクエスト例：

```
const response = await fetch('/api/about', {  
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
  "message": "",  
  "data": "# 关于我们\n\nNew API是一个强大的AI网关系统..."  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取关于信息失败"  
}
```

🧾 フィールド説明：

`data` （文字列）: 「このシステムについて」ページの内容。Markdown形式またはURLリンクをサポートしています。

### ホームページのカスタムコンテンツ

- **インターフェース名**：ホームページのカスタムコンテンツ
- **HTTP メソッド**：GET
- **パス**：`/api/home_page_content`
- **認証要件**：公開
- **機能概要**：ホームぺージのカスタムコンテンツを取得します。Markdownテキストまたはiframe URLが可能です。

💡 リクエスト例：

```
const response = await fetch('/api/home_page_content', {  
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
  "message": "",  
  "data": "# 欢迎使用New API\n\n这是一个功能强大的AI网关系统..."  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取首页内容失败"  
}
```

🧾 フィールド説明：

`data` （文字列）: ホームページの内容。Markdownテキスト、または"https://"で始まる URL リンクが可能です。

### モデルレート設定

- **インターフェース名**：モデルレート設定
- **HTTP メソッド**：GET
- **パス**：`/api/ratio_config`
- **認証要件**：公開
- **機能概要**：公開されているモデルレート設定情報を取得し、アップストリームシステムとの同期に使用します。

💡 リクエスト例：

```
const response = await fetch('/api/ratio_config', {  
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
  "data": {  
    "model_ratio": {  
      "gpt-3.5-turbo": 1.0,  
      "gpt-4": 15.0,  
      "claude-3-sonnet": 3.0  
    },  
    "completion_ratio": {  
      "gpt-3.5-turbo": 1.0,  
      "gpt-4": 1.0  
    },  
    "model_price": {  
      "gpt-3.5-turbo-instruct": 0.002  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取倍率配置失败"  
}
```

🧾 フィールド説明：

`data` （オブジェクト）: レート設定情報

- `model_ratio` （オブジェクト）: モデルレートマッピング。キーはモデル名、値はレート数値です。
- `completion_ratio` （オブジェクト）: 補完レートマッピング
- `model_price` （オブジェクト）: モデル価格マッピング。キーはモデル名、値は価格（米ドル）です。

### 価格とプラン情報

- **インターフェース名**：価格とプラン情報
- **HTTP メソッド**：GET
- **パス**：`/api/pricing`
- **認証要件**：匿名/ユーザー
- **機能概要**：モデルの価格設定情報、グループレート、および利用可能なグループを取得します。

💡 リクエスト例：

```
const response = await fetch('/api/pricing', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_token' // オプション。ログインユーザーはより詳細な情報を取得できます
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "data": [  
    {  
      "model_name": "gpt-3.5-turbo",  
      "enable_group": ["default", "vip"],  
      "model_ratio": 1.0,  
      "completion_ratio": 1.0,  
      "model_price": 0.002,  
      "quota_type": 1,  
      "description": "GPT-3.5 Turbo模型",  
      "vendor_id": 1,  
      "supported_endpoint_types": [1, 2]  
    }  
  ],  
  "vendors": [  
    {  
      "id": 1,  
      "name": "OpenAI",  
      "description": "OpenAI官方模型",  
      "icon": "openai.png"  
    }  
  ],  
  "group_ratio": {  
    "default": 1.0,  
    "vip": 0.8  
  },  
  "usable_group": {  
    "default": "默认分组",  
    "vip": "VIP分组"  
  },  
  "supported_endpoint": {  
    "1": {"method": "POST", "path": "/v1/chat/completions"},  
    "2": {"method": "POST", "path": "/v1/embeddings"}  
  },  
  "auto_groups": ["default"]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取定价信息失败"  
}
```

🧾 フィールド説明：

- `data` （配列）: モデル価格設定情報リスト

    - `model_name` （文字列）: モデル名称
    - `enable_group` （配列）: 利用可能なグループリスト
    - `model_ratio` （数値）: モデルレート
    - `completion_ratio` （数値）: 補完レート
    - `model_price` （数値）: モデル価格（米ドル）
    - `quota_type` （数値）: 課金タイプ。0=レート課金、1=価格課金
    - `description` （文字列）: モデルの説明
    - `vendor_id` （数値）: ベンダー ID
    - `supported_endpoint_types` （配列）: サポートされているエンドポイントタイプ
- `vendors` （配列）: ベンダー情報リスト

    - `id` （数値）: ベンダー ID
    - `name` （文字列）: ベンダー名称
    - `description` （文字列）: ベンダーの説明
    - `icon` （文字列）: ベンダーアイコン
- `group_ratio` （オブジェクト）: グループレートマッピング
- `usable_group` （オブジェクト）: 利用可能なグループマッピング
- `supported_endpoint` （オブジェクト）: サポートされているエンドポイント情報
- `auto_groups` （配列）: 自動グループリスト

## 🔐 ユーザー認証

### フロントエンドで利用可能なモデルリストの取得

- **インターフェース名**：フロントエンドで利用可能なモデルリストの取得
- **HTTP メソッド**：GET
- **パス**：`/api/models`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーがアクセス可能な AI モデルのリストを取得し、フロントエンドのダッシュボード表示に使用します。

💡 リクエスト例：

```
const response = await fetch('/api/models', {  
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
  "data": {  
    "1": ["gpt-3.5-turbo", "gpt-4"],  
    "2": ["claude-3-sonnet", "claude-3-haiku"]  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "未授权访问"  
}
```

🧾 フィールド説明：

`data` （オブジェクト）: チャネル ID からモデルリストへのマッピング

- キー （文字列）: チャネル ID
- 値 （配列）: 当該チャネルがサポートするモデル名のリスト