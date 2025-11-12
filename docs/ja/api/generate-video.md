# 動画生成 API

動画生成インターフェースを呼び出して動画を生成します。以下の複数の動画生成サービスをサポートしています：

- **可霊AI (Kling)**: [APIドキュメント](https://app.klingai.com/cn/dev/document-api/apiReference/commonInfo)
- **即夢 (Jimeng)**: [APIドキュメント](https://www.volcengine.com/docs/85621/1538636)
- **Gemini**: Googleの動画生成サービス
- **Vidu**: 高品質動画生成サービス

## NewAPI 動画生成フォーマット

### API エンドポイント

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
| metadata | object | いいえ | ベンダー固有/カスタムパラメータ（例：negative_prompt, style, quality_level など） |
| n | integer | いいえ | 生成する動画の数 |
| response_format | string | いいえ | レスポンスフォーマット |
| seed | integer | いいえ | ランダムシード |
| user | string | いいえ | ユーザー識別子 |

### リクエスト例

#### 可霊AI の例

```bash
curl https://你的newapi服务器地址/v1/video/generations \
  --request POST \
  --header 'Authorization: Bearer sk-xxxx' \
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

#### 即夢AI の例

```bash
curl https://你的newapi服务器地址/v1/video/generations \
  --request POST \
  --header 'Authorization: Bearer sk-xxxx' \
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
  --header 'Authorization: Bearer sk-xxxx' \
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

### レスポンスフォーマット

#### 201 - 作成成功

```json
{
  "id": "video_123",
  "object": "video",
  "model": "kling-v1",
  "created_at": 1640995200,
  "task_id": "abcd1234efgh",
  "status": "processing"
}
```

#### レスポンスフィールドの説明

| フィールド | 型 | 説明 |
|------|------|------|
| id | string | 動画タスクID |
| object | string | オブジェクトタイプ。「video」で固定 |
| model | string | 使用されたモデル名 |
| created_at | integer | 作成タイムスタンプ |
| task_id | string | タスクID。ステータス照会に使用 |
| status | string | タスクステータス（processing: 処理中） |

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

## サポートされているモデル

### 可霊AI (Kling)
- `kling-v1`: テキスト to ビデオ モデル
- `kling-v2-master`: 画像 to ビデオ モデル

### 即夢 (Jimeng)
- `jimeng_vgfm_t2v_l20`: テキスト to ビデオ モデル
- `jimeng_vgfm_i2v_l20`: 画像 to ビデオ モデル

### Vidu
- `viduq1`: Vidu 高品質動画生成モデル

## ベストプラクティス

1. **プロンプトの最適化**: スタイルや品質要件を含む、詳細で具体的な記述を使用します
2. **画像品質**: 画像から動画を生成する際は、高解像度で鮮明な画像を使用します
3. **パラメータ調整**: 要件に応じて、長さ、解像度などのパラメータを調整します
4. **エラー処理**: 適切なリトライメカニズムとエラー処理を実装します
5. **非同期処理**: 動画生成は非同期タスクであるため、ステータスをポーリングして確認する必要があります