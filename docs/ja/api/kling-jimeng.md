# Kling AI (Kling) および Jimeng 形式

動画生成APIを呼び出して動画を生成します。複数の動画生成サービスをサポートしています。

- **Kling AI (Kling)**: [APIドキュメント](https://app.klingai.com/cn/dev/document-api/apiReference/commonInfo)
- **Jimeng (Jimeng)**: [APIドキュメント](https://www.volcengine.com/docs/85621/1538636)

## 動画生成

### APIエンドポイント

```
POST /v1/video/generations
```

### リクエストヘッダー

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| Authorization | string | はい | ユーザー認証トークン (Bearer: sk-xxxx) |
| Content-Type | string | はい | application/json |

### リクエストパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| model | string | はい | モデル/スタイルID |
| prompt | string | はい | テキストプロンプト |
| duration | number | いいえ | 動画の長さ（秒） |
| fps | integer | いいえ | 動画フレームレート |
| height | integer | いいえ | 動画の高さ |
| width | integer | いいえ | 動画の幅 |
| image | string | いいえ | 画像入力（URL/Base64） |
| metadata | object | いいえ | ベンダー固有/カスタムパラメータ（例: negative_prompt, style, quality_level など） |
| n | integer | いいえ | 生成する動画の数 |
| response_format | string | いいえ | レスポンス形式 |
| seed | integer | いいえ | シード値 (Seed) |
| user | string | いいえ | ユーザー識別子 |

### リクエスト例

#### Kling AI の例

```bash
curl https://你的newapi服务器地址/v1/video/generations \
  --request POST \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "kling-v1",
  "prompt": "一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级",
  "size": "1920x1080",
  "image": "https://h2.inkwai.com/bs2/upload-ylab-stunt/se/ai_portal_queue_mmu_image_upscale_aiweb/3214b798-e1b4-4b00-b7af-72b5b0417420_raw_image_0.jpg",
  "duration": 5,
  "metadata": {
    "seed": 20231234,
    "negative_prompt": "模糊",
    "image_tail": "https://h1.inkwai.com/bs2/upload-ylab-stunt/1fa0ac67d8ce6cd55b50d68b967b3a59.png"
  }
}'
```

#### Jimeng AI の例

```bash
curl https://你的newapi服务器地址/v1/video/generations \
  --request POST \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "jimeng_vgfm_t2v_l20",
  "prompt": "一个穿着宇航服的宇航员在月球上行走",
  "image": "https://h2.inkwai.com/bs2/upload-ylab-stunt/se/ai_portal_queue_mmu_image_upscale_aiweb/3214b798-e1b4-4b00-b7af-72b5b0417420_raw_image_0.jpg",
  "metadata": {
    "req_key": "jimeng_vgfm_i2v_l20",
    "image_urls": [
      "https://h2.inkwai.com/bs2/upload-ylab-stunt/se/ai_portal_queue_mmu_image_upscale_aiweb/3214b798-e1b4-4b00-b7af-72b5b0417420_raw_image_0.jpg"
    ],
    "aspect_ratio": "16:9"
  }
}'
```

#### Vidu チャネルの例

```bash
curl https://你的newapi服务器地址/v1/video/generations \
  --request POST \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "viduq1",
  "prompt": "一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级",
  "size": "1920x1080",
  "image": "https://prod-ss-images.s3.cn-northwest-1.amazonaws.com.cn/vidu-maas/template/image2video.png",
  "duration": 5,
  "metadata": {
    "duration": 5,
    "seed": 0,
    "resolution": "1080p",
    "movement_amplitude": "auto",
    "bgm": false,
    "payload": "",
    "callback_url": "https://your-callback-url.com/webhook"
  }
}'
```

## 動画の照会

タスクIDに基づいて動画生成タスクのステータスと結果を照会します。

### APIエンドポイント

```
GET /v1/video/generations/{task_id}
```

### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| task_id | string | はい | タスクID |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/video/generations/{task_id}'
```

### レスポンス形式

#### 200 - 成功レスポンス

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

#### レスポンスフィールドの説明

| フィールド | 型 | 説明 |
|------|------|------|
| task_id | string | タスクID |
| status | string | タスクステータス（processing: 処理中, succeeded: 成功, failed: 失敗） |
| format | string | 動画形式 |
| url | string | 動画リソースURL（成功時） |
| metadata | object | 結果メタデータ |
| error | object | エラー情報（成功時はnull） |

## エラーレスポンス

### 400 - リクエストパラメータエラー
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 401 - 未認証 (Unauthorized)
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 403 - 権限なし (Forbidden)
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 500 - サーバー内部エラー
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```