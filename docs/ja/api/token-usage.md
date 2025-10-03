## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス許容量 | Available service quota for users |

# トークン使用量照会（Token Usage）

!!! info "機能説明"
    認証を通じて、現在のBearer Tokenのクォータ使用状況（付与総量、使用済み、残量、無制限かどうか、モデル制限、および有効期限）を照会します。

## 📮 エンドポイント

```
GET /api/usage/token
```

- リクエストヘッダーに認証情報を含める必要があります
- 現在のリクエストで使用された Token の使用量情報のみを返します

## 🔐 認証

リクエストヘッダーに以下の内容を含めて API キー認証を行います：

```
Authorization: Bearer $NEWAPI_API_KEY
```

- `sk-` プレフィックスの有無にかかわらずサポートします。サーバー側で自動的に互換性を確保します
- Authorization ヘッダーがない、または無効な場合は 401 が返されます

## 💡 リクエスト例

```bash
curl -X GET https://你的newapi服务器地址/api/usage/token \
  -H "Authorization: Bearer $NEWAPI_API_KEY"
```

## ✅ 成功レスポンス例

```json
{
  "code": true,
  "message": "ok",
  "data": {
    "object": "token_usage",
    "name": "Default Token",
    "total_granted": 1000000,
    "total_used": 12345,
    "total_available": 987655,
    "unlimited_quota": false,
    "model_limits": {
      "gpt-4o-mini": true
    },
    "model_limits_enabled": false,
    "expires_at": 0
  }
}
```

## ❗ エラーレスポンス例

- 認証ヘッダーがない場合：

```json
{
  "success": false,
  "message": "No Authorization header"
}
```

- Bearerスキームではない場合：

```json
{
  "success": false,
  "message": "Invalid Bearer token"
}
```

- Tokenの検索に失敗した場合（例：無効または削除済み）：

```json
{
  "success": false,
  "message": "token not found"
}
```

## 🧾 フィールド説明（data）

- `object`: 固定値 `token_usage`
- `name`: トークン名
- `total_granted`: 付与総量（= 使用済み + 残量）
- `total_used`: 使用済みクォータ
- `total_available`: 利用可能な残りのクォータ
- `unlimited_quota`: 無制限クォータであるかどうか
- `model_limits`: 使用が許可されているモデルのリスト
- `model_limits_enabled`: モデル制限が有効になっているかどうか
- `expires_at`: 有効期限の Unix タイムスタンプ（秒）。永続的な場合は `0` を返します（バックエンドによって `-1` が `0` に正規化されます）

---

> 参考実装：`GET /api/usage/token` は PR [#1161](https://github.com/QuantumNous/new-api/pull/1161) で追加されました