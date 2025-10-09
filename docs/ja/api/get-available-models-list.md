# 利用可能なモデルリストの取得（Model）

!!! info "説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています。

    本番環境では、認証トークンを保護するために HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

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
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'Bearer your_user_id'
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

 🧾 フィールドの説明：

- `data` （オブジェクト）: チャネル ID からモデルリストへのマッピング
    - キー （文字列）: チャネル ID
    - 値 （配列）: そのチャネルがサポートするモデル名のリスト