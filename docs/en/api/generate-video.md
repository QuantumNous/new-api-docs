# Generate Video

Call the video generation API to generate videos, supporting multiple video generation services:

- **Kling AI**: [API Documentation](https://app.klingai.com/cn/dev/document-api/apiReference/commonInfo)
- **Jimeng**: [API Documentation](https://www.volcengine.com/docs/85621/1538636)

## API Endpoint

```
POST /v1/video/generations
```

## Headers

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| Authorization | string | Yes | User authentication token (Bearer: sk-xxxx) |
| Content-Type | string | Yes | application/json |

## Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| model | string | Yes | Model/style ID |
| prompt | string | Yes | Text prompt |
| duration | number | No | Video duration (seconds) |
| fps | integer | No | Video frame rate |
| height | integer | No | Video height |
| width | integer | No | Video width |
| image | string | No | Image input (URL/Base64) |
| metadata | object | No | Vendor-specific/custom params (e.g. negative_prompt, style, quality_level, etc.) |
| n | integer | No | Number of videos to generate |
| response_format | string | No | Response format |
| seed | integer | No | Random seed |
| user | string | No | User identifier |

## Request Example

### Kling AI Example

```bash
curl https://your-newapi-server-address/v1/video/generations \
  --request POST \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "kling-v1",
  "prompt": "An astronaut in a spacesuit walking on the moon, high quality, cinematic",
  "size": "1920x1080",
  "image": "https://h2.inkwai.com/bs2/upload-ylab-stunt/se/ai_portal_queue_mmu_image_upscale_aiweb/3214b798-e1b4-4b00-b7af-72b5b0417420_raw_image_0.jpg",
  "duration": 5,
  "metadata": {
    "seed": 20231234,
    "negative_prompt": "blurry",
    "image_tail": "https://h1.inkwai.com/bs2/upload-ylab-stunt/1fa0ac67d8ce6cd55b50d68b967b3a59.png"
  }
}'
```

### Jimeng AI Example

```bash
curl https://your-newapi-server-address/v1/video/generations \
  --request POST \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "jimeng_vgfm_t2v_l20",
  "prompt": "An astronaut in a spacesuit walking on the moon",
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

### Vidu Channel Example

```bash
curl https://your-newapi-server-address/v1/video/generations \
  --request POST \
  --header 'Authorization: ' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "viduq1",
  "prompt": "An astronaut in a spacesuit walking on the moon, high quality, cinematic",
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

## Response Format

### Error Responses

#### 400 - Invalid Request
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 401 - Unauthorized
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 403 - Forbidden
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 500 - Internal Server Error
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```
