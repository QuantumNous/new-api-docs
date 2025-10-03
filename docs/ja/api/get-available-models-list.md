## コア概念 (Core Concepts)

| 中国語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| 渠道 | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| 分组 | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# 利用可能なモデルリストの取得（Model）

!!! info "説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` で統一されています

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

- **インターフェース名**：フロントエンドで利用可能なモデルリストの取得
- **HTTP メソッド**：GET
- **パス**：`/api/models`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーがアクセス可能な AI モデルのリストを取得し、フロントエンドのダッシュボード表示に使用します

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

- `data` （オブジェクト）: チャネル ID からモデルリストへのマッピング
    - キー （文字列）: チャネル ID
    - 値 （配列）: そのチャネルがサポートするモデル名のリスト