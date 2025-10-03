## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# 兌換コード管理モジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    管理者専用の兌換コードシステムです。一括生成、ステータス管理、検索フィルタリングなどの機能をサポートしています。無効な兌換コードを自動的にクリーンアップするメンテナンス機能も含まれています。主にプロモーション活動やユーザーインセンティブに使用されます。

## 🔐 管理者認証

### 兌換コードリストの取得

- **インターフェース名**：兌換コードリストの取得
- **HTTP メソッド**：GET
- **パス**：`/api/redemption/`
- **認証要件**：管理者
- **機能概要**：システム内のすべての兌換コードのリスト情報をページングして取得します

💡 リクエスト例：

```
const response = await fetch('/api/redemption/?p=1&page_size=20', {  
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
  "message": "",  
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "name": "新年活动兑换码",  
        "key": "abc123def456",  
        "status": 1,  
        "quota": 100000,  
        "created_time": 1640908800,  
        "redeemed_time": 0,  
        "expired_time": 1640995200,  
        "used_user_id": 0  
      }  
    ],  
    "total": 50,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "获取兑换码列表失败"  
}
```

🧾 フィールド説明：

- `p` （数字）: ページ番号、デフォルトは 1
- `page_size` （数字）: 1ページあたりの数量、デフォルトは 20
- `items` （配列）: 兌換コード情報リスト 
- `total` （数字）: 兌換コードの総数
- `page` （数字）: 現在のページ番号
- `page_size` （数字）: 1ページあたりの数量

### 兌換コードの検索

- **インターフェース名**：兌換コードの検索
- **HTTP メソッド**：GET
- **パス**：`/api/redemption/search`
- **認証要件**：管理者
- **機能概要**：キーワードに基づいて兌換コードを検索します。IDと名称による検索をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/redemption/search?keyword=新年&p=1&page_size=20', {  
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
  "message": "",  
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "name": "新年活动兑换码",  
        "key": "abc123def456",  
        "status": 1,  
        "quota": 100000  
      }  
    ],  
    "total": 1,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "搜索兑换码失败"  
}
```

🧾 フィールド説明：

- `keyword` （文字列）: 検索キーワード。兌換コードの名称または ID に一致します。
- `p` （数字）: ページ番号、デフォルトは 1
- `page_size` （数字）: 1ページあたりの数量、デフォルトは 20

### 個別兌換コードの取得

- **インターフェース名**：個別兌換コードの取得
- **HTTP メソッド**：GET
- **パス**：`/api/redemption/:id`
- **認証要件**：管理者
- **機能概要**：指定された兌換コードの詳細情報を取得します。

💡 リクエスト例：

```
const response = await fetch('/api/redemption/123', {  
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
  "message": "",  
  "data": {  
    "id": 123,  
    "name": "新年活动兑换码",  
    "key": "abc123def456",  
    "status": 1,  
    "quota": 100000,  
    "created_time": 1640908800,  
    "redeemed_time": 0,  
    "expired_time": 1640995200,  
    "used_user_id": 0,  
    "user_id": 1  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "兑换码不存在"  
}
```

🧾 フィールド説明：

`id` （数字）: 兌換コード ID。URLパスを通じて渡されます。

### 兌換コードの作成

- **インターフェース名**：兌換コードの作成
- **HTTP メソッド**：POST
- **パス**：`/api/redemption/`
- **認証要件**：管理者
- **機能概要**：兌換コードを一括作成します。一度に複数作成できます。

💡 リクエスト例：

```
const response = await fetch('/api/redemption/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    name: "春节活动兑换码",  
    count: 10,  
    quota: 100000,  
    expired_time: 1640995200  
  })  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    "abc123def456",  
    "def456ghi789",  
    "ghi789jkl012"  
  ]  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "兑换码名称长度必须在1-20之间"  
}
```

🧾 フィールド説明：

- `name` （文字列）: 兌換コード名。長さは 1～20文字である必要があります。
- `count` （数字）: 作成する兌換コードの数量。0より大きく、100を超えてはなりません。
- `quota` （数字）: 各兌換コードのクォータ数量。
- `expired_time` （数字）: 有効期限タイムスタンプ。0 は永続を意味します。
- `data` （配列）: 正常に作成された兌換コードのリスト。

### 兌換コードの更新

- **インターフェース名**：兌換コードの更新
- **HTTP メソッド**：PUT
- **パス**：`/api/redemption/`
- **認証要件**：管理者
- **機能概要**：兌換コード情報を更新します。ステータスのみの更新、または完全な更新をサポートしています。

💡 リクエスト例（完全更新）：

```
const response = await fetch('/api/redemption/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    name: "更新的兑换码名称",  
    quota: 200000,  
    expired_time: 1672531200  
  })  
});  
const data = await response.json();
```

💡 リクエスト例（ステータスのみ更新）：

```
const response = await fetch('/api/redemption/?status_only=true', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    status: 2  
  })  
});  
const data = await response.json();
```

✅ 成功応答例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "id": 123,  
    "name": "更新的兑换码名称",  
    "status": 1,  
    "quota": 200000,  
    "expired_time": 1672531200  
  }  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "过期时间不能早于当前时间"  
}
```

🧾 フィールド説明：

- `id` （数字）: 兌換コード ID。必須。
- `status_only` （クエリパラメータ）: ステータスのみを更新するかどうか。
- `name` （文字列）: 兌換コード名。オプション。
- `quota` （数字）: クォータ数量。オプション。
- `expired_time` （数字）: 有効期限タイムスタンプ。オプション。
- `status` （数字）: 兌換コードのステータス。オプション。

### 無効な兌換コードの削除

- **インターフェース名**：無効な兌換コードの削除
- **HTTP メソッド**：DELETE
- **パス**：`/api/redemption/invalid`
- **認証要件**：管理者
- **機能概要**：使用済み、無効化済み、または期限切れの兌換コードを一括削除します。

💡 リクエスト例：

```
const response = await fetch('/api/redemption/invalid', {  
  method: 'DELETE',  
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
  "message": "",  
  "data": 15  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "删除失败"  
}
```

🧾 フィールド説明：

- リクエストパラメータなし
- `data` （数字）: 削除された兌換コードの数量。

### 兌換コードの削除

- **インターフェース名**：兌換コードの削除
- **HTTP メソッド**：DELETE
- **パス**：`/api/redemption/:id`
- **認証要件**：管理者
- **機能概要**：指定された兌換コードを削除します。

💡 リクエスト例：

```
const response = await fetch('/api/redemption/123', {  
  method: 'DELETE',  
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
  "message": ""  
}
```

❗ 失敗応答例：

```
{  
  "success": false,  
  "message": "兑换码不存在"  
}
```

🧾 フィールド説明：

`id` （数字）: 兌換コード ID。URLパスを通じて渡されます。