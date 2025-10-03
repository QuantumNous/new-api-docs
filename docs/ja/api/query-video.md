# 動画の照会

タスクIDに基づいて、動画生成タスクのステータスと結果を照会します

## APIエンドポイント

```
GET /v1/video/generations/{task_id}
```

## パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
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
| format | string | 動画形式 |
| url | string | 動画リソースURL（成功時） |
| metadata | object | 結果メタデータ |
| error | object | エラー情報（成功時はnull） |

### エラーレスポンス

#### 400 - リクエストパラメータエラー
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