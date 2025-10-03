# モデルレート同期モジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    モデルの価格設定同期に特化した高度な機能です。複数のアップストリームソースからレート設定を並行して取得し、異なるインターフェース形式を自動的に識別し、データ信頼性の評価を提供します。主にモデルの価格設定情報を一括更新するために使用されます。

## 🔐 Root認証

### 同期可能なチャネルリストの取得

- **インターフェース名**：同期可能なチャネルリストの取得
- **HTTP メソッド**：GET
- **パス**：`/api/ratio_sync/channels`
- **認証要件**：Root
- **機能概要**：システム内でレート同期に使用できるすべてのチャネルリストを取得します。これには、有効な BaseURL を持つチャネルと公式のプリセットが含まれます。

💡 リクエスト例：

```
const response = await fetch('/api/ratio_sync/channels', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
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
  "message": "获取渠道列表失败"  
}
```

🧾 フィールド説明：

- `data` （配列）: 同期可能なチャネルリスト 
    - `id` （数値）: チャネル ID、-100 は公式プリセット
    - `name` （文字列）: チャネル名
    - `base_url` （文字列）: チャネルベース URL
    - `status` （数値）: チャネルステータス、1=有効

### アップストリームからレートを取得

- **インターフェース名**：アップストリームからレートを取得
- **HTTP メソッド**：POST
- **パス**：`/api/ratio_sync/fetch`
- **認証要件**：Root
- **機能概要**：指定されたアップストリームチャネルまたはカスタム URL からモデルレート設定を取得します。並行取得と差異比較をサポートします。

💡 リクエスト例（チャネル ID 経由）：

```
const response = await fetch('/api/ratio_sync/fetch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
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
    'Authorization': 'Bearer your_root_token'  
  },  
  body: JSON.stringify({  
    upstreams: [  
      {  
        name: "自定义源",  
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
            "官方倍率预设(-100)": "same"  
          },  
          "confidence": {  
            "OpenAI公式(1)": true,  
            "官方倍率预设(-100)": true  
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
        "error": "连接超时"  
      }  
    ]  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "无有效上游渠道"  
}
```

🧾 フィールド説明：

- `channel_ids` （配列）: 同期するチャネル ID のリスト、オプション 
- `upstreams` （配列）: カスタムアップストリーム設定リスト、オプション 
    - `name` （文字列）: アップストリーム名
    - `base_url` （文字列）: ベース URL、http で始まる必要があります
    - `endpoint` （文字列）: インターフェースエンドポイント、デフォルトは "/api/ratio_config"
- `timeout` （数値）: リクエストタイムアウト時間（秒）、デフォルトは 10 秒 
- `differences` （オブジェクト）: 差異化レート比較結果 
    - キーはモデル名、値には各レートタイプの差異情報が含まれます
    - `current`： ローカルの現在の値
    - `upstreams`： 各アップストリームの値、"same" はローカルと同じであることを示します
    - `confidence`： データ信頼性、false は信頼できない可能性があることを示します 
- `test_results` （配列）: 各アップストリームのテスト結果