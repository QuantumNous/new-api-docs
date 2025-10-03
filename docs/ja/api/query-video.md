## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス資格情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響します | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# 動画の照会

タスクIDに基づいて動画生成タスクのステータスと結果を照会します

## APIエンドポイント

```
GET /v1/video/generations/{task_id}
```

## パスパラメーター

| パラメーター | 型 | 必須 | 説明 |
|------|------|------|------|
| task_id | string | はい | タスクID |

## リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/video/generations/{task_id}'
```

## レスポンス形式

### 200 - 成功レスポンス

```json
{
  "error": null,
  "format": "mp4",
  "metadata": {
    "duration": 5,
    "fps": 30,
    "height": 512,
    "seed": 20231234,
    "width": 512
  },
  "status": "succeeded",
  "task_id": "abcd1234efgh",
  "url": "string"
}
```

### レスポンスフィールドの説明

| フィールド | 型 | 説明 |
|------|------|------|
| task_id | string | タスクID |
| status | string | タスクステータス（processing: 処理中, succeeded: 成功, failed: 失敗） |
| format | string | 動画フォーマット |
| url | string | 動画リソースURL（成功時） |
| metadata | object | 結果メタデータ |
| error | object | エラー情報（成功時はnull） |

### エラーレスポンス

#### 400 - リクエストパラメーターエラー
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 401 - 未認証
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 403 - 権限なし
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 500 - サーバー内部エラー
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```