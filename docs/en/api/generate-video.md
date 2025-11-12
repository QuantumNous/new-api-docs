# Video Generation API

Call the video generation interface to generate videos, supporting various video generation services:

- **Kling AI (Kling)**: [API Documentation](https://app.klingai.com/cn/dev/document-api/apiReference/commonInfo)
- **Jimeng**: [API Documentation](https://www.volcengine.com/docs/85621/1538636)
- **Gemini**: Google's video generation service
- **Vidu**: High-quality video generation service

## NewAPI Video Generation Format

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
| metadata | object | No | Vendor-specific/Custom Parameters (e.g., negative_prompt, style, quality_level, etc.) |
| n | integer | No | Number of Videos to Generate |
| response_format | string | No | Response Format |
| seed | integer | No | Random Seed |
| user | string | No | User Identifier |

### Request Examples

#### Kling AI Example

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

#### Jimeng AI Example

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

#### Vidu Channel Example

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

### Response Format

#### 201 - Created Successfully

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

#### Response Field Description

| Field | Type | Description |
|------|------|------|
| id | string | Video Task ID |
| object | string | Object type, fixed as "video" |
| model | string | Name of the model used |
| created_at | integer | Creation Timestamp |
| task_id | string | Task ID, used for status query |
| status | string | Task Status (processing: in progress) |

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

## Supported Models

### Kling AI (Kling)
- `kling-v1`: Text-to-Video Model
- `kling-v2-master`: Image-to-Video Model

### Jimeng
- `jimeng_vgfm_t2v_l20`: Text-to-Video Model
- `jimeng_vgfm_i2v_l20`: Image-to-Video Model

### Vidu
- `viduq1`: Vidu High-Quality Video Generation Model

## Best Practices

1. **Prompt Optimization**: Use detailed, specific descriptive words, including style and quality requirements
2. **Image Quality**: Use high-resolution, clear images for image-to-video generation
3. **Parameter Tuning**: Adjust parameters like duration and resolution according to requirements
4. **Error Handling**: Implement appropriate retry mechanisms and error handling
5. **Asynchronous Processing**: Video generation is an asynchronous task, requiring polling for status checks