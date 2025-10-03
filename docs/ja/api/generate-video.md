## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| レート | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格レートに影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# 動画の生成

動画生成APIを呼び出して動画を生成します。複数の動画生成サービスをサポートしています：

- **可灵AI (Kling)**: [APIドキュメント](https://app.klingai.com/cn/dev/document-api/apiReference/commonInfo)
- **即梦 (Jimeng)**: [APIドキュメント](https://www.volcengine.com/docs/85621/1538636)

## APIエンドポイント

```
POST /v1/video/generations
```

## リクエストヘッダー

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| Authorization | string | はい | ユーザー認証トークン (Bearer: sk-xxxx) |
| Content-Type | string | はい | application/json |

## リクエストパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| model | string | はい | モデル/スタイルID |
| prompt | string | はい | テキストプロンプト |
| duration | number | いいえ | 動画の長さ（秒） |
| fps | integer | いいえ | 動画のフレームレート |
| height | integer | いいえ | 動画の高さ |
| width | integer | いいえ | 動画の幅 |
| image | string | いいえ | 画像入力（URL/Base64） |
| metadata | object | いいえ | ベンダー固有/カスタムパラメータ（例: negative_prompt, style, quality_level など） |
| n | integer | いいえ | 生成する動画の数 |
| response_format | string | いいえ | レスポンス形式 |
| seed | integer | いいえ | ランダムシード |
| user | string | いいえ | ユーザー識別子 |

## リクエスト例

### 可灵AIの例

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

### 即梦AIの例

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

### Viduチャネルの例

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

## レスポンス形式

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