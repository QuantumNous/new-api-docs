# サイト設定モジュール

!!! info "機能説明"
    APIプレフィックスは http(s)://`<your-domain>` に統一されています。

    認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    最高権限のシステム設定管理であり、Rootユーザーのみがアクセス可能です。グローバルパラメータ設定、モデル比率のリセット、コンソール設定の移行などの機能を含みます。設定の更新には、厳格な依存関係検証ロジックが含まれています。

## 🔐 Root認証

### グローバル設定の取得
- **API名**：グローバル設定の取得
- **HTTPメソッド**：GET
- **パス**：`/api/option/`
- **認証要件**：Root
- **機能概要**：システム全体のすべてのグローバル設定オプションを取得します。Token、Secret、Keyなどの機密情報はフィルタリングされます。
💡 リクエスト例：

```
const response = await fetch('/api/option/', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'Bearer your_user_id'
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
      "key": "SystemName",  
      "value": "New API"  
    },  
    {  
      "key": "DisplayInCurrencyEnabled",  
      "value": "true"  
    },  
    {  
      "key": "QuotaPerUnit",  
      "value": "500000"  
    }  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取配置失败"  
}
```

🧾 フィールド説明：

`data` （配列）: 設定項目リスト option.go：15-18

- `key` （文字列）: 設定項目キー名
- `value` （文字列）: 設定項目の値。機密情報は既にフィルタリングされています option.go：22-24


### グローバル設定の更新

- **API名**：グローバル設定の更新
- **HTTPメソッド**：PUT
- **パス**：`/api/option/`
- **認証要件**：Root
- **機能概要**：個別のグローバル設定項目を更新します。設定検証と依存関係チェックが含まれます。

💡 リクエスト例：

```
const response = await fetch('/api/option/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'Bearer your_user_id'
  },  
  body: JSON.stringify({  
    key: "SystemName",  
    value: "My New API System"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "配置更新成功"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "无法启用 GitHub OAuth，请先填入 GitHub Client Id 以及 GitHub Client Secret！"  
}
```

🧾 フィールド説明：

- `key` （文字列）: 設定項目キー名、必須 option.go：39-42
- `value` （任意型）: 設定項目の値。ブール型、数値、文字列などの型をサポートします option.go：54-63

### モデル比率のリセット

- **API名**：モデル比率のリセット
- **HTTPメソッド**：POST
- **パス**：`/api/option/rest_model_ratio`
- **認証要件**：Root
- **機能概要**：すべてのモデルの比率設定をデフォルト値にリセットします。モデル価格設定の一括リセットに使用されます。

💡 リクエスト例：

```
const response = await fetch('/api/option/rest_model_ratio', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "模型倍率重置成功"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "重置模型倍率失败"  
}
```

🧾 フィールド説明：

リクエストパラメータなし。実行後、すべてのモデル比率設定がリセットされます。

### 旧バージョンコンソール設定の移行

- **API名**：旧バージョンコンソール設定の移行
- **HTTPメソッド**：POST
- **パス**：`/api/option/migrate_console_setting`
- **認証要件**：Root
- **機能概要**：旧バージョンのコンソール設定を、API情報、お知らせ、FAQなどを含む新しい設定形式に移行します。

💡 リクエスト例：

```
const response = await fetch('/api/option/migrate_console_setting', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token',
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "migrated"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "迁移失败"  
}
```

🧾 フィールド説明：

- リクエストパラメータなし
- 移行内容：

    - `ApiInfo` → `console_setting.api_info` 
    - `Announcements` → `console_setting.announcements` 
    - `FAQ` → `console_setting.faq` 
    - `UptimeKumaUrl/UptimeKumaSlug` → `console_setting.uptime_kuma_groups`