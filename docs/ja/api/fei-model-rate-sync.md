# モデルレート同期モジュール

!!! info "機能説明"
    インターフェースプレフィックスは http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    モデルの価格設定同期に特化した高度な機能です。複数のアップストリームソースからレート設定を並行して取得し、異なるインターフェース形式を自動的に識別し、データ信頼性評価を提供します。主にモデルの価格設定情報の一括更新に使用されます。

## 🔐 Root認証

### 同期可能なチャネルリストの取得

- **インターフェース名称**：同期可能なチャネルリストの取得
- **HTTP メソッド**：GET
- **パス**：`/api/ratio_sync/channels`
- **認証要件**：Root
- **機能概要**：システム内でレート同期に使用できるすべてのチャネルのリストを取得します。これには有効な BaseURL を持つチャネルと公式プリセットが含まれます。

💡 リクエスト例：

```
const response = await fetch('/api/ratio_sync/channels', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
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
  "data": [  
    {  
      "id": 1,  
      "name": "OpenAI公式",  
      "base_url": "https://api.openai.com",  
      "status": 1  
    },  
    {  
      "id": 2,  
      "name": "Claude API",  
      "base_url": "https://api.anthropic.com",  
      "status": 1  
    },  
    {  
      "id": -100,  
      "name": "公式レートプリセット",  
      "base_url": "https://basellm.github.io",  
      "status": 1  
    }  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "チャネルリストの取得に失敗しました"  
}
```

🧾 フィールド説明：

- `data` （配列）: 同期可能なチャネルリスト 
    - `id` （数値）: チャネル ID、-100 は公式プリセット
    - `name` （文字列）: チャネル名
    - `base_url` （文字列）: チャネルベース URL
    - `status` （数値）: チャネルステータス、1=有効

### アップストリームからレートを取得

- **インターフェース名称**：アップストリームからレートを取得
- **HTTP メソッド**：POST
- **パス**：`/api/ratio_sync/fetch`
- **認証要件**：Root
- **機能概要**：指定されたアップストリームチャネルまたはカスタム URL からモデルレート設定を取得します。並行取得と差異比較をサポートしています。

💡 リクエスト例（チャネル ID 経由）：

```
const response = await fetch('/api/ratio_sync/fetch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    channel_ids: [1, 2, -100],  
    timeout: 10  
  })  
});  
const data = await response.json();
```

💡 リクエスト例（カスタム URL 経由）：

```
const response = await fetch('/api/ratio_sync/fetch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    upstreams: [  
      {  
        name: "カスタム源",  
        base_url: "https://example.com",  
        endpoint: "/api/ratio_config"  
      }  
    ],  
    timeout: 15  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "data": {  
    "differences": {  
      "gpt-4": {  
        "model_ratio": {  
          "current": 15.0,  
          "upstreams": {  
            "OpenAI公式(1)": 20.0,  
            "公式レートプリセット(-100)": "same"  
          },  
          "confidence": {  
            "OpenAI公式(1)": true,  
            "公式レートプリセット(-100)": true  
          }  
        }  
      },  
      "claude-3-sonnet": {  
        "model_price": {  
          "current": null,  
          "upstreams": {  
            "Claude API(2)": 0.003  
          },  
          "confidence": {  
            "Claude API(2)": true  
          }  
        }  
      }  
    },  
    "test_results": [  
      {  
        "name": "OpenAI公式(1)",  
        "status": "success"  
      },  
      {  
        "name": "Claude API(2)",  
        "status": "error",  
        "error": "接続タイムアウト"  
      }  
    ]  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "有効なアップストリームチャネルがありません"  
}
```

🧾 フィールド説明：

- `channel_ids` （配列）: 同期するチャネル ID のリスト、オプション 
- `upstreams` （配列）: カスタムアップストリーム設定リスト、オプション 

    - `name` （文字列）: アップストリーム名
    - `base_url` （文字列）: ベース URL、http で始まる必要があります
    - `endpoint` （文字列）: インターフェースエンドポイント、デフォルトは"/api/ratio_config"
- `timeout` （数値）: リクエストタイムアウト時間（秒）、デフォルトは 10 秒 
- `differences` （オブジェクト）: 差異化レート比較結果 

    - キーはモデル名、値は各レートタイプの差異情報を含む
    - `current`： ローカルの現在の値
    - `upstreams`： 各アップストリームの値、"same" はローカルと同じであることを示す
    - `confidence`： データ信頼性、false は信頼できない可能性があることを示す 
- `test_results` （配列）: 各アップストリームのテスト結果