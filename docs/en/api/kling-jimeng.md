# Kling AI and Jimeng Formats

Call the video generation interface to generate videos, supporting multiple video generation services:

- **Kling AI**: [API Documentation](https://app.klingai.com/cn/dev/document-api/apiReference/commonInfo)
- **Jimeng**: [API Documentation](https://www.volcengine.com/docs/85621/1538636)

## Generate Video

### API Endpoint

```
POST /v1/video/generations
```

### Request Headers

| Parameter | Type | Required | Description |
|------|------|------|------|
| Authorization | string | Yes | User Authentication Token (Bearer: sk-xxxx) |
| Content-Type | string | Yes | application/json |

### Request Parameters

| Parameter | Type | Required | Description |
|------|------|------|------|
| model | string | Yes | Model/Style ID |
| prompt | string | Yes | Text Prompt |
| duration | number | No | Video Duration (seconds) |
| fps | integer | No | Video Frame Rate (FPS) |
| height | integer | No | Video Height |
| width | integer | No | Video Width |
| image | string | No | Image Input (URL/Base64) |
| metadata | object | No | Vendor Specific/Custom Parameters (e.g., negative_prompt, style, quality_level, etc.) |
| n | integer | No | Number of Videos to Generate |
| response_format | string | No | Response Format |
| seed | integer | No | Random Seed |
| user | string | No | User Identifier |

### Request Examples

#### Kling AI Example

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

#### Jimeng AI Example

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

#### Vidu Channel Example

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

## Query Video

Query the status and results of the video generation task based on the Task ID

### API Endpoint

```
GET /v1/video/generations/{task_id}
```

### Path Parameters

| Parameter | Type | Required | Description |
|------|------|------|------|
| task_id | string | Yes | Task ID |

### Request Example

```bash
curl 'https://你的newapi服务器地址/v1/video/generations/{task_id}'
```

### Response Format

#### 200 - Successful Response

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

#### Response Field Description

| Field | Type | Description |
|------|------|------|
| task_id | string | Task ID |
| status | string | Task Status (processing, succeeded, failed) |
| format | string | Video Format |
| url | string | Video Resource URL (on success) |
| metadata | object | Result Metadata |
| error | object | Error Information (null on success) |

## Error Responses

### 400 - Request Parameter Error
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 401 - Unauthorized
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 403 - Forbidden
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 500 - Internal Server Error
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```