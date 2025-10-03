## コア概念 (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 比率/レート | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格比率に影響する | Classification of users or tokens, affecting price ratios |
| クォータ/利用枠 | Quota | ユーザーが利用可能なサービス利用枠 | Available service quota for users |

# サイト設定モジュール

!!! info "機能説明"
    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています

    本番環境では認証トークンを保護するために HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    最高権限のシステム設定管理であり、Rootユーザーのみがアクセス可能です。グローバルパラメータ設定、モデル比率のリセット、コンソール設定の移行などの機能が含まれます。設定の更新には厳格な依存関係検証ロジックが含まれます。

## 🔐 Root認証

### グローバル設定の取得
- **インターフェース名**：グローバル設定の取得
- **HTTP メソッド**：GET
- **パス**：`/api/option/`
- **認証要件**：Root
- **機能概要**：システム全体のすべてのグローバル設定オプションを取得します。Token、Secret、Keyなどの機密情報はフィルタリングされます。
💡 リクエスト例：

```
const response = await fetch('/api/option/', {  
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
  "message": "設定の取得に失敗しました"  
}
```

🧾 フィールド説明：

`data` （配列）: 設定項目リスト option.go：15-18

- `key` （文字列）: 設定項目のキー名
- `value` （文字列）: 設定項目の値。機密情報はフィルタリング済み option.go：22-24


### グローバル設定の更新

- **インターフェース名**：グローバル設定の更新
- **HTTP メソッド**：PUT
- **パス**：`/api/option/`
- **認証要件**：Root
- **機能概要**：単一のグローバル設定項目を更新します。設定検証と依存関係チェックが含まれます

💡 リクエスト例：

```
const response = await fetch('/api/option/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_root_token'  
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
  "message": "設定の更新に成功しました"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "無法啟用 GitHub OAuth，請先填入 GitHub Client Id 以及 GitHub Client Secret！"  
}
```

🧾 フィールド説明：

- `key` （文字列）: 設定項目のキー名（必須） option.go：39-42
- `value` （任意の型）: 設定項目の値。ブール型、数値、文字列などの型をサポートします option.go：54-63

### モデル比率のリセット

- **インターフェース名**：モデル比率のリセット
- **HTTP メソッド**：POST
- **パス**：`/api/option/rest_model_ratio`
- **認証要件**：Root
- **機能概要**：すべてのモデルの比率設定をデフォルト値にリセットします。モデル価格設定の一括リセットに使用されます。

💡 リクエスト例：

```
const response = await fetch('/api/option/rest_model_ratio', {  
  method: 'POST',  
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
  "message": "モデル比率のリセットに成功しました"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "モデル比率のリセットに失敗しました"  
}
```

🧾 フィールド説明：

リクエストパラメータはありません。実行後、すべてのモデル比率設定がリセットされます。

### 旧版コンソール設定の移行

- **インターフェース名**：旧版コンソール設定の移行
- **HTTP メソッド**：POST
- **パス**：`/api/option/migrate_console_setting`
- **認証要件**：Root
- **機能概要**：旧バージョンのコンソール設定を新しい設定形式に移行します。API情報、お知らせ、FAQなどが含まれます。

💡 リクエスト例：

```
const response = await fetch('/api/option/migrate_console_setting', {  
  method: 'POST',  
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
  "message": "migrated"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "移行に失敗しました"  
}
```

🧾 フィールド説明：

- リクエストパラメータなし
- 移行内容：

    - `ApiInfo` → `console_setting.api_info` 
    - `Announcements` → `console_setting.announcements` 
    - `FAQ` → `console_setting.faq` 
    - `UptimeKumaUrl/UptimeKumaSlug` → `console_setting.uptime_kuma_groups`