## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| レート | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格レートに影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# グループモジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    シンプルなグループ名照会インターフェースです。主に管理者インターフェースのドロップダウン選択コンポーネントに使用され、ユーザー側のグループインターフェースとは異なり、レートなどの詳細情報を含まず、名前リストのみを返します。

## 🔐 管理者認証

### 全グループリストの取得

- **インターフェース名**：全グループリストの取得
- **HTTP メソッド**：GET
- **パス**：`/api/group/`
- **認証要件**：管理者
- **機能概要**：システム内の全ユーザーグループの名前リストを取得します。管理者による設定やフロントエンドコンポーネントの選択に使用されます。

💡 リクエスト例：

```
const response = await fetch('/api/group/', {  
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
  "data": [  
    "default",  
    "vip",  
    "premium",  
    "enterprise"  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "グループリストの取得に失敗しました"  
}
```

🧾 フィールド説明：

`data` （配列）: グループ名リスト。システム内で設定されているすべてのユーザーグループ名が含まれます。