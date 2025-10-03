# チャネル管理モジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています

    本番環境では、認証トークンを保護するために HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。

    AIサービスプロバイダーチャネルの完全な管理システムです。チャネルの追加、削除、変更、検索、一括操作、接続性テスト、残高照会、タグ管理などの機能をサポートしています。モデル機能の同期やチャネルの複製などの高度な機能も含まれています。

## 🔐 管理者認証


### チャネルリストの取得

- **インターフェース名**：チャネルリストの取得
- **HTTPメソッド**：GET
- **パス**：`/api/channel/`
- **認証要件**：管理者
- **機能概要**：システム内のすべてのチャネルのリスト情報をページングして取得します。タイプ、ステータスによるフィルタリング、およびタグモードをサポートしています

💡 リクエスト例：

```
const response = await fetch('/api/channel/?p=1&page_size=20&id_sort=false&tag_mode=false&type=1&status=enabled', {  
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
        "name": "OpenAI渠道",  
        "type": 1,  
        "status": 1,  
        "priority": 10,  
        "weight": 100,  
        "models": "gpt-3.5-turbo,gpt-4",  
        "group": "default",  
        "response_time": 1500,  
        "test_time": 1640995200  
      }
    ],  
    "total": 50,  
    "type_counts": {  
      "1": 20,  
      "2": 15,  
      "all": 35  
    }  
  }  
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

- `p` （数値）: ページ番号。デフォルトは 1
- `page_size` （数値）: 1ページあたりの数量。デフォルトは 20
- `id_sort` （ブール型）: IDでソートするかどうか。デフォルトは優先度でソート
- `tag_mode` （ブール型）: タグモードを有効にするかどうか
- `type` （数値）: チャネルタイプのフィルタリング
- `status` （文字列）: ステータスフィルタリング。オプション値："enabled"、"disabled"、"all"

### チャネルの検索

- **インターフェース名**：チャネルの検索
- **HTTPメソッド**：GET
- **パス**：`/api/channel/search`
- **認証要件**：管理者
- **機能概要**：キーワード、グループ、モデルなどの条件に基づいてチャネルを検索します

💡 リクエスト例：

```
const response = await fetch('/api/channel/search?keyword=openai&group=default&model=gpt-4&id_sort=false&tag_mode=false&p=1&page_size=20&type=1&status=enabled', {  
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
        "name": "OpenAI官方渠道",  
        "type": 1,  
        "status": 1,  
        "models": "gpt-3.5-turbo,gpt-4",  
        "group": "default"  
      }  
    ],  
    "total": 1,  
    "type_counts": {  
      "1": 1,  
      "all": 1  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{    "success": false,    "message": "チャネルの検索に失敗しました"  }
```

🧾 フィールド説明：

- `keyword` （文字列）: 検索キーワード。チャネル名と一致させることができます
- `group` （文字列）: グループフィルタリング条件
- `model` （文字列）: モデルフィルタリング条件
- その他のパラメータはチャネルリスト取得インターフェースと同じです

### チャネルモデル機能の照会

- **インターフェース名**：チャネルモデル機能の照会
- **HTTPメソッド**：GET
- **パス**：`/api/channel/models`
- **認証要件**：管理者
- **機能概要**：システム内のすべてのチャネルがサポートするモデルリストを取得します

💡 リクエスト例：

```
const response = await fetch('/api/channel/models', {  
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
    {  
      "id": "gpt-3.5-turbo",  
      "name": "GPT-3.5 Turbo"  
    },  
    {  
      "id": "gpt-4",  
      "name": "GPT-4"  
    },  
    {  
      "id": "claude-3-sonnet",  
      "name": "Claude 3 Sonnet"  
    }  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "モデルリストの取得に失敗しました"  
}
```

🧾 フィールド説明：

`data` （配列）: モデル情報リスト

- `id` （文字列）: モデル ID
- `name` （文字列）: モデル表示名

### 有効なモデル機能の照会

- **インターフェース名**：有効なモデル機能の照会
- **HTTPメソッド**：GET
- **パス**：`/api/channel/models_enabled`
- **認証要件**：管理者
- **機能概要**：現在有効なチャネルがサポートするモデルリストを取得します

💡 リクエスト例：

```
const response = await fetch('/api/channel/models_enabled', {  
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
    "gpt-3.5-turbo",  
    "gpt-4",  
    "claude-3-sonnet"  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "有効なモデルの取得に失敗しました"  
}
```

🧾 フィールド説明：

`data` （配列）: 有効化されたモデル ID リスト

### 単一チャネルの取得

- **インターフェース名**：単一チャネルの取得
- **HTTPメソッド**：GET
- **パス**：`/api/channel/:id`
- **認証要件**：管理者
- **機能概要**：指定されたチャネルの詳細情報を取得します。機密性の高いキー情報は含まれません。

💡 リクエスト例：

```
const response = await fetch('/api/channel/123', {  
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
    "id": 123,  
    "name": "OpenAI渠道",  
    "type": 1,  
    "status": 1,  
    "priority": 10,  
    "weight": 100,  
    "models": "gpt-3.5-turbo,gpt-4",  
    "group": "default",  
    "base_url": "https://api.openai.com",  
    "model_mapping": "{}",  
    "channel_info": {  
      "is_multi_key": false,  
      "multi_key_mode": "random"  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "チャネルが存在しません"  
}
```

🧾 フィールド説明：

- `id` （数値）: チャネル ID。URLパスを通じて渡されます
- 完全なチャネル情報が返されますが、キーフィールドは含まれません

### チャネル接続性の一括テスト

- **インターフェース名**：チャネル接続性の一括テスト
- **HTTPメソッド**：GET
- **パス**：`/api/channel/test`
- **認証要件**：管理者
- **機能概要**：すべてまたは指定されたチャネルの接続性と応答時間を一括でテストします

💡 リクエスト例：

```
const response = await fetch('/api/channel/test?model=gpt-3.5-turbo', {  
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
  "message": "一括テストが完了しました",  
  "data": {  
    "total": 10,  
    "success": 8,  
    "failed": 2,  
    "results": [  
      {  
        "channel_id": 1,  
        "channel_name": "OpenAI渠道",  
        "success": true,  
        "time": 1.25,  
        "message": ""  
      },  
      {  
        "channel_id": 2,  
        "channel_name": "Claude渠道",  
        "success": false,  
        "time": 0,  
        "message": "接続タイムアウト"  
      }  
    ]  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "一括テストに失敗しました"  
}
```

🧾 フィールド説明：

- `model` （文字列）: オプション。テストモデルを指定します
- `results` （配列）: テスト結果リスト
    - `success` （ブール型）: テストが成功したかどうか
    - `time` （数値）: 応答時間（秒）

### 単一チャネルのテスト

- **インターフェース名**：単一チャネルのテスト
- **HTTPメソッド**：GET
- **パス**：`/api/channel/test/:id`
- **認証要件**：管理者
- **機能概要**：指定されたチャネルの接続性をテストします。テストモデルの指定をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/channel/test/123?model=gpt-4', {  
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
  "time": 1.25  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "APIキーが無効です",  
  "time": 0.5  
}
```

🧾 フィールド説明：

- `id` （数値）: チャネル ID。URLパスを通じて渡されます
- `model` （文字列）: オプション。テストするモデル名を指定します
- `time` （数値）: 応答時間（秒）

### 残高の一括更新

- **インターフェース名**：残高の一括更新
- **HTTPメソッド**：GET
- **パス**：`/api/channel/update_balance`
- **認証要件**：管理者
- **機能概要**：すべての有効なチャネルの残高情報を一括で更新します

💡 リクエスト例：

```
const response = await fetch('/api/channel/update_balance', {  
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
  "message": "残高の一括更新が完了しました"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "残高の一括更新に失敗しました"  
}
```

🧾 フィールド説明：

リクエストパラメータなし。システムはすべての有効なチャネルの残高を自動的に更新します

### 単一チャネルの残高更新

- **インターフェース名**：指定チャネルの残高更新
- **HTTPメソッド**：GET
- **パス**：`/api/channel/update_balance/:id`
- **認証要件**：管理者
- **機能概要**：指定されたチャネルの残高情報を更新します。マルチキーチャネルは残高照会をサポートしていません。

💡 リクエスト例：

```
const response = await fetch('/api/channel/update_balance/123', {  
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
  "balance": 25.50  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "マルチキーチャネルは残高照会をサポートしていません"  
}
```

🧾 フィールド説明：

- `id` （数値）: チャネル ID。URLパスを通じて渡されます
- `balance` （数値）: 更新後のチャネル残高

### チャネルの新規追加

- **インターフェース名**：新規チャネルの追加
- **HTTPメソッド**：POST
- **パス**：`/api/channel/`
- **認証要件**：管理者
- **機能概要**：新しい AI サービスチャネルを作成します。単一、一括、およびマルチキーモードをサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/channel/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    mode: "single",  
    channel: {  
      name: "OpenAI渠道",  
      type: 1,  
      key: "<YOUR_API_KEY>",  
      base_url: "https://api.openai.com",  
      models: ["gpt-3.5-turbo", "gpt-4"],  
      groups: ["default"],  
      priority: 10,  
      weight: 100  
    }  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "サポートされていない追加モードです"  
}
```

🧾 フィールド説明：

- `mode` （文字列）: 追加モード。オプション値："single"、"batch"、"multi_to_single" 
- `multi_key_mode` （文字列）: マルチキーモード。"mode"が"multi_to_single"の場合に必須
- `channel` （オブジェクト）: チャネル設定情報
    - `name` （文字列）: チャネル名
    - `type` （数値）: チャネルタイプ
    - `key` （文字列）: APIキー
    - `base_url` （文字列）: ベース URL
    - `models` （配列）: サポートされているモデルリスト
    - `groups` （配列）: 利用可能なグループリスト
    - `priority` （数値）: 優先度
    - `weight` （数値）: 重み

### チャネルの更新

- **インターフェース名**：チャネルの更新
- **HTTPメソッド**：PUT
- **パス**：`/api/channel/`
- **認証要件**：管理者
- **機能概要**：既存のチャネルの設定情報を更新します

💡 リクエスト例：

```
const response = await fetch('/api/channel/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    id: 123,  
    name: "更新的OpenAI渠道",  
    status: 1,  
    priority: 15,  
    weight: 120  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "チャネルが存在しません"  
}
```

🧾 フィールド説明：

- `id` （数値）: チャネル ID。必須
- その他のフィールドは新規チャネル追加インターフェースと同じで、すべてオプションです

### 無効化されたチャネルの削除

- **インターフェース名**：無効化されたチャネルの削除
- **HTTPメソッド**：DELETE
- **パス**：`/api/channel/disabled`
- **認証要件**：管理者
- **機能概要**：すべての無効化されたチャネルを一括で削除します

💡 リクエスト例：

```
const response = await fetch('/api/channel/disabled', {  
  method: 'DELETE',  
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
  "data": 5  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "削除に失敗しました"  
}
```

🧾 フィールド説明：

- リクエストパラメータなし
- `data` （数値）: 削除されたチャネルの数

### タグ付きチャネルの一括無効化

- **インターフェース名**：タグ付きチャネルの一括無効化
- **HTTPメソッド**：POST
- **パス**：`/api/channel/tag/disabled`
- **認証要件**：管理者
- **機能概要**：タグに基づいてチャネルを一括で無効化します

💡 リクエスト例：

```
const response = await fetch('/api/channel/tag/disabled', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    tag: "test-tag"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "パラメータエラー"  
}
```

🧾 フィールド説明：

`tag` （文字列）: 無効化するチャネルタグ。必須

### タグ付きチャネルの一括有効化

- **インターフェース名**：タグ付きチャネルの一括有効化
- **HTTPメソッド**：POST
- **パス**：`/api/channel/tag/enabled`
- **認証要件**：管理者
- **機能概要**：タグに基づいてチャネルを一括で有効化します

💡 リクエスト例：

```
const response = await fetch('/api/channel/tag/enabled', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    tag: "production-tag"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "パラメータエラー"  
}
```

🧾 フィールド説明：

`tag` （文字列）: 有効化するチャネルタグ。必須

### チャネルタグの編集

- **インターフェース名**：チャネルタグの編集
- **HTTPメソッド**：PUT
- **パス**：`/api/channel/tag`
- **認証要件**：管理者
- **機能概要**：指定されたタグを持つチャネル属性を一括で編集します

💡 リクエスト例：

```
const response = await fetch('/api/channel/tag', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    tag: "old-tag",  
    new_tag: "new-tag",  
    priority: 20,  
    weight: 150,  
    models: "gpt-3.5-turbo,gpt-4,claude-3-sonnet",  
    groups: "default,vip"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "tagを空にすることはできません"  
}
```

🧾 フィールド説明：

- `tag` （文字列）: 編集するタグ名。必須
- `new_tag` （文字列）: 新しいタグ名。オプション
- `priority` （数値）: 新しい優先度。オプション
- `weight` （数値）: 新しい重み。オプション
- `model_mapping` （文字列）: モデルマッピング設定。オプション
- `models` （文字列）: サポートされているモデルリスト。カンマ区切り。オプション
- `groups` （文字列）: 利用可能なグループリスト。カンマ区切り。オプション

### チャネルの削除

- **インターフェース名**：チャネルの削除
- **HTTPメソッド**：DELETE
- **パス**：`/api/channel/:id`
- **認証要件**：管理者
- **機能概要**：指定されたチャネルをハード削除します。削除後、チャネルキャッシュが更新されます。

💡 リクエスト例：

```
const response = await fetch('/api/channel/123', {  
  method: 'DELETE',  
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
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "チャネルが存在しません"  
}
```

🧾 フィールド説明：

`id` （数値）: チャネル ID。URLパスを通じて渡されます

### チャネルの一括削除

- **インターフェース名**：チャネルの一括削除
- **HTTPメソッド**：POST
- **パス**：`/api/channel/batch`
- **認証要件**：管理者
- **機能概要**：IDリストに基づいてチャネルを一括で削除します

💡 リクエスト例：

```
const response = await fetch('/api/channel/batch', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    ids: [1, 2, 3, 4, 5]  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": 5  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "パラメータエラー"  
}
```

🧾 フィールド説明：

- `ids` （配列）: 削除するチャネル ID リスト。必須であり、空であってはなりません
- `data` （数値）: 正常に削除されたチャネルの数

### チャネル機能テーブルの修復

- **インターフェース名**：チャネル機能テーブルの修復
- **HTTPメソッド**：POST
- **パス**：`/api/channel/fix`
- **認証要件**：管理者
- **機能概要**：チャネル機能テーブルのデータを修復し、チャネルとモデルのマッピング関係を再構築します

💡 リクエスト例：

```
const response = await fetch('/api/channel/fix', {  
  method: 'POST',  
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
    "success": 45,  
    "fails": 2  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "機能テーブルの修復に失敗しました"  
}
```

🧾 フィールド説明：

- リクエストパラメータなし
- `data.success` （数値）: 正常に修復されたチャネルの数
- `data.fails` （数値）: 修復に失敗したチャネルの数

### 単一チャネルモデルの取得

- **インターフェース名**：単一チャネルモデルの取得
- **HTTPメソッド**：GET
- **パス**：`/api/channel/fetch_models/:id`
- **認証要件**：管理者
- **機能概要**：指定されたチャネルのアップストリーム API から利用可能なモデルリストを取得します

💡 リクエスト例：

```
const response = await fetch('/api/channel/fetch_models/123', {  
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
    "gpt-3.5-turbo",  
    "gpt-4",  
    "gpt-4-turbo-preview"  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "解析応答失敗: invalid character 'H' looking for beginning of value"  
}
```

🧾 フィールド説明：

- `id` （数値）: チャネル ID。URLパスを通じて渡されます
- `data` （配列）: アップストリームから取得されたモデル ID リスト

### 全チャネルモデルの取得

- **インターフェース名**：全チャネルモデルの取得
- **HTTPメソッド**：POST
- **パス**：`/api/channel/fetch_models`
- **認証要件**：管理者
- **機能概要**：提供された設定情報を使用してアップストリーム API からモデルリストを取得します。これは新規チャネル作成時のプレビューに使用されます。

💡 リクエスト例：

```
const response = await fetch('/api/channel/fetch_models', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    base_url: "https://api.openai.com",  
    type: 1,  
    key: "<YOUR_API_KEY>"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "data": [  
    "gpt-3.5-turbo",  
    "gpt-4",  
    "text-davinci-003"  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "Failed to fetch models"  
}
```

🧾 フィールド説明：

- `base_url` （文字列）: ベース URL。オプション。空の場合はデフォルト URL を使用
- `type` （数値）: チャネルタイプ。必須
- `key` （文字列）: APIキー。必須
- `data` （配列）: 取得されたモデルリスト

### チャネルタグの一括設定

- **インターフェース名**：チャネルタグの一括設定
- **HTTPメソッド**：POST
- **パス**：`/api/channel/batch/tag`
- **認証要件**：管理者
- **機能概要**：指定されたチャネルリストにタグを一括で設定します

💡 リクエスト例：

```
const response = await fetch('/api/channel/batch/tag', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
  },  
  body: JSON.stringify({  
    ids: [1, 2, 3],  
    tag: "production"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": 3  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "パラメータエラー"  
}
```

🧾 フィールド説明：

- `ids` （配列）: タグを設定するチャネル ID リスト。必須であり、空であってはなりません
- `tag` （文字列）: 設定するタグ名。nullを渡すとタグをクリアできます
- `data` （数値）: タグ設定に成功したチャネルの数

### タグによるモデルの取得

- **インターフェース名**：タグによるモデルの取得
- **HTTPメソッド**：GET
- **パス**：`/api/channel/tag/models`
- **認証要件**：管理者
- **機能概要**：指定されたタグを持つすべてのチャネルの中で、モデル数が最も多いモデルリストを取得します

💡 リクエスト例：

```
const response = await fetch('/api/channel/tag/models?tag=production', {  
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
  "data": "gpt-3.5-turbo,gpt-4,claude-3-sonnet"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "tagを空にすることはできません"  
}
```

🧾 フィールド説明：

- `tag` （文字列）: タグ名。必須
- `data` （文字列）: そのタグの下で最もモデルが多いチャネルのモデルリスト。カンマ区切り

### チャネルの複製

- **インターフェース名**：チャネルの複製
- **HTTPメソッド**：POST
- **パス**：`/api/channel/copy/:id`
- **認証要件**：管理者
- **機能概要**：既存のチャネルを複製して新しいチャネルを作成します。カスタムサフィックスと残高リセットオプションをサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/channel/copy/123?suffix=_备份&reset_balance=true', {  
  method: 'POST',  
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
    "id": 124  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "invalid id"  
}
```

🧾 フィールド説明：

- `id` （数値）: 複製するチャネル ID。URLパスを通じて渡されます
- `suffix` （文字列）: オプション。元の名前に付加するサフィックス。デフォルトは"_复制" (コピー)
- `reset_balance` （ブール型）: オプション。残高と使用済みクォータを 0 にリセットするかどうか。デフォルトは true
- `data.id` （数値）: 新しく作成されたチャネル ID