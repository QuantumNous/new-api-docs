# グループモジュール

!!! info "機能説明"
    APIプレフィックスは http(s)://`<your-domain>` に統一されています。

    本番環境では認証トークンを保護するために HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    シンプルなグループ名照会APIです。主に管理者インターフェースのドロップダウン選択コンポーネントに使用され、ユーザー側のグループAPIとは異なり、レートなどの詳細情報を含まず、名前リストのみを返します。

## 🔐 管理者認証

### 全グループリストの取得

- **API名**：全グループリストの取得
- **HTTPメソッド**：GET
- **パス**：`/api/group/`
- **認証要件**：管理者
- **機能概要**：システム内のすべてのユーザーグループの名前リストを取得します。管理者による設定やフロントエンドコンポーネントの選択に使用されます。

💡 リクエスト例：

```
const response = await fetch('/api/group/', {  
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
  "message": "获取分组列表失败"  
}
```

🧾 フィールド説明：

`data` （配列）: グループ名リスト。システム内で設定されているすべてのユーザーグループ名が含まれます。