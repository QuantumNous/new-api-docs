# OpenAI Video Format (Sora Format)

Generate videos by calling the OpenAI video generation interface, supporting models like Sora, and also supporting the use of the OpenAI video format to call Kling, Jimeng, and Vidu.

## Generate Video

### API Endpoint

```
POST /v1/videos
```

### Request Headers

| Parameter | Type | Required | Description |
|------|------|------|------|
| Authorization | string | Yes | User Authentication Token (Bearer: sk-xxxx) |

### Request Parameters (multipart/form-data)

| Parameter | Type | Required | Description |
|------|------|------|------|
| prompt | string | Yes | Text prompt describing the video to be generated |
| model | string | No | Video generation model, defaults to sora-2 |
| seconds | string | No | Video duration (seconds), defaults to 4 seconds |
| size | string | No | Output resolution, format is width x height, defaults to 720x1280 |
| input_reference | file | No | Input image file (used for Image-to-Video), the input image must match the corresponding width and height (size) |
| metadata | string | No | Extended parameters (JSON string format) |

#### metadata Parameter Description

The purpose of the metadata parameter is to pass parameters specific to non-Sora models, such as Aliyun Wanxiang's image URL, watermark, and prompt intelligent rewriting. The format of the metadata parameter is a JSON string, for example:
```json
{
  "img_url": "https://example.com/image.jpg",
  "watermark": false,
  "prompt_extend": true
}
```

### Request Examples

#### Text-to-Video (Text Prompt Only)

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级" \
  -F "model=sora-2" \
  -F "seconds=5" \
  -F "size=1920x1080"
```

#### Image-to-Video (Text Prompt + Image File)

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=猫咪慢慢睁开眼睛，伸懒腰" \
  -F "model=sora-2" \
  -F "seconds=3" \
  -F "size=1920x1080" \
  -F "input_reference=@/path/to/cat.jpg"
```

#### Aliyun Wanxiang Video Generation Example

##### Text-to-Video (Wanxiang 2.5)
```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=一只可爱的小猫在花园里玩耍，阳光明媚，色彩鲜艳" \
  -F "model=wan2.5-t2v-preview" \
  -F "seconds=5" \
  -F "size=1920*1080"
```

##### Image-to-Video (Wanxiang 2.5)
```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=让这张图片动起来，添加自然的运动效果" \
  -F "model=wan2.5-i2v-preview" \
  -F "seconds=5" \
  -F "size=1280P" \
  -F 'metadata={"img_url":"https://example.com/image.jpg"}'
```

### Response Format

#### 201 - Created Successfully

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "created_at": 1640995200,
  "status": "processing",
  "progress": 0
}
```

#### Response Field Description

| Field | Type | Description |
|------|------|------|
| id | string | Video Task ID |
| object | string | Object type, fixed as "video" |
| model | string | Name of the model used |
| created_at | integer | Creation timestamp |
| status | string | Task status (processing: in progress) |
| progress | integer | Generation progress percentage |

## Query Video

Query the status and result of the video generation task based on the Task ID

### API Endpoint

```
GET /v1/videos/{video_id}
```

### Path Parameters

| Parameter | Type | Required | Description |
|------|------|------|------|
| video_id | string | Yes | Video Task ID |

### Request Example

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

### Response Format

#### 200 - Successful Response

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "created_at": 1640995200,
  "status": "succeeded",
  "progress": 100,
  "expires_at": 1641081600,
  "size": "1920x1080",
  "seconds": "5",
  "quality": "standard"
}
```

#### Response Field Description

| Field | Type | Description |
|------|------|------|
| id | string | Video Task ID |
| object | string | Object type, fixed as "video" |
| model | string | Name of the model used |
| created_at | integer | Creation timestamp |
| status | string | Task status (processing: in progress, succeeded: successful, failed: failed) |
| progress | integer | Generation progress percentage |
| expires_at | integer | Resource expiration timestamp |
| size | string | Video resolution |
| seconds | string | Video duration (seconds) |
| quality | string | Video quality |
| url | string | Video download link (upon completion) |

## Get Video Task Status

Retrieve detailed information about the video generation task based on the Task ID

### API Endpoint

```
GET /v1/videos/{video_id}
```

### Path Parameters

| Parameter | Type | Required | Description |
|------|------|------|------|
| video_id | string | Yes | Identifier of the video task to retrieve |

### Request Example

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

### Response Format

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "created_at": 1640995200,
  "status": "succeeded",
  "progress": 100,
  "expires_at": 1641081600,
  "size": "1920x1080",
  "seconds": "5",
  "quality": "standard",
  "remixed_from_video_id": null,
  "error": null
}
```

#### Response Field Description

| Field | Type | Description |
|------|------|------|
| id | string | Unique identifier for the video task |
| object | string | Object type, fixed as "video" |
| model | string | Name of the model generating the video |
| status | string | Current lifecycle status of the video task |
| progress | integer | Approximate completion percentage of the generation task |
| created_at | integer | Unix timestamp (seconds) when the task was created |
| expires_at | integer | Unix timestamp (seconds) when the downloadable resource expires, if set |
| size | string | Resolution of the generated video |
| seconds | string | Duration (seconds) of the generated video clip |
| quality | string | Video quality |
| remixed_from_video_id | string | Identifier of the source video if this video is a remix |
| error | object | Object containing error information if generation failed |

## Get Video Content

Download the completed video content

### API Endpoint

```
GET /v1/videos/{video_id}/content
```

### Path Parameters

| Parameter | Type | Required | Description |
|------|------|------|------|
| video_id | string | Yes | Identifier of the video to download |

### Query Parameters

| Parameter | Type | Required | Description |
|------|------|------|------|
| variant | string | No | Type of downloadable resource to return, defaults to MP4 video |

### Request Example

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

### Response Description

Directly returns the video file stream, Content-Type is `video/mp4`

#### Response Headers

| Field | Description |
|------|------|
| Content-Type | Video file type, usually video/mp4 |
| Content-Length | Video file size (bytes) |
| Content-Disposition | File download information |

## Error Responses

### 400 - Request Parameter Error
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 401 - Unauthorized
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 403 - No Permission
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 404 - Task Does Not Exist
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 500 - Internal Server Error
```json
{
  "error": {
    "message": "string",
    "type": "server_error"
  }
}
```

## Supported Models

### OpenAI Compatible
- `sora-2`: Sora video generation model

### Other Services Called via OpenAI Format
- Aliyun Wanxiang (Ali Wan): Uses `wan2.5-t2v-preview` (Text-to-Video), `wan2.5-i2v-preview` (Image-to-Video), `wan2.2-i2v-flash`, `wan2.2-i2v-plus`, `wanx2.1-i2v-plus`, `wanx2.1-i2v-turbo`
- Kling AI (Kling): Uses `kling-v1`, `kling-v2-master`
- Jimeng: Uses `jimeng_vgfm_t2v_l20`, `jimeng_vgfm_i2v_l20`
- Vidu: Uses `viduq1`

## Aliyun Wanxiang Special Instructions

### Supported Features
- **Text-to-Video (t2v)**: Generates video using only a text prompt
- **Image-to-Video (i2v)**: Generates video using a text prompt + image
- **Keyframe-to-Video (kf2v)**: Generates video by specifying the first and last frame images
- **Audio Generation (s2v)**: Supports combining audio with video

### Resolution Support
- **480P**: 832×480, 480×832, 624×624
- **720P**: 1280×720, 720×1280, 960×960, 1088×832, 832×1088
- **1080P**: 1920×1080, 1080×1920, 1440×1440, 1632×1248, 1248×1632

### Special Parameters
- `watermark`: Whether to add a watermark (default false)
- `prompt_extend`: Whether to enable prompt intelligent rewriting (default true)
- `audio`: Whether to add audio (only supported by wan2.5)
- `seed`: Random seed

### Model Characteristics
- **wan2.5-i2v-preview**: Wanxiang 2.5 preview version, supports video with sound, recommended
- **wan2.2-i2v-flash**: Wanxiang 2.2 Flash version, fast generation speed, silent video
- **wan2.2-i2v-plus**: Wanxiang 2.2 Pro version, higher image quality, silent video
- **wanx2.1-i2v-plus**: Wanxiang 2.1 Pro version, stable version
- **wanx2.1-i2v-turbo**: Wanxiang 2.1 Turbo version

## Best Practices

1. **Request Format**: Use `multipart/form-data` format, which is the official OpenAI recommended method
2. **input_reference Parameter**: Used for Image-to-Video functionality, use the `@filename` syntax when uploading an image file
3. **Prompt Optimization**: Use detailed and specific descriptive words, including style and quality requirements
4. **Parameter Settings**: Set duration and resolution reasonably according to requirements
5. **Aliyun Wanxiang Special Instructions**:
   - **Direct file upload is not supported**, all resources are passed via URL
   - Use the `metadata` parameter to pass all extended parameters (JSON string format)
   - Image-to-Video uses `metadata.img_url` to pass the image URL
   - Keyframe-to-Video uses `metadata.first_frame_url` and `metadata.last_frame_url`
6. **Error Handling**: Implement appropriate retry mechanisms and error handling
7. **Asynchronous Processing**: Video generation is an asynchronous task, requiring polling for status checks
8. **Resource Management**: Download and clean up unnecessary video files promptly

## JavaScript Example

### Using FormData (Recommended)

```javascript
async function generateVideoWithFormData() {
  const formData = new FormData();
  formData.append('prompt', '一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级');
  formData.append('model', 'sora-2');
  formData.append('seconds', '5');
  formData.append('size', '1920x1080');

  const response = await fetch('https://你的newapi服务器地址/v1/videos', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer sk-xxxx'
    },
    body: formData
  });

  const result = await response.json();
  return result.id;
}

// Image-to-Video Example
async function generateVideoWithImage() {
  const formData = new FormData();
  formData.append('prompt', '猫咪慢慢睁开眼睛，伸懒腰');
  formData.append('model', 'sora-2');
  formData.append('seconds', '3');
  formData.append('size', '1920x1080');
  
  // 添加图片文件
  const imageFile = document.getElementById('imageInput').files[0];
  formData.append('input_reference', imageFile);

  const response = await fetch('https://你的newapi服务器地址/v1/videos', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer sk-xxxx'
    },
    body: formData
  });

  const result = await response.json();
  return result.id;
}
```

### Aliyun Wanxiang Calling Example

```javascript
// Aliyun Wanxiang Text-to-Video
async function generateAliVideo() {
  const formData = new FormData();
  formData.append('prompt', '一只可爱的小猫在花园里玩耍，阳光明媚，色彩鲜艳');
  formData.append('model', 'wan2.5-t2v-preview');
  formData.append('seconds', '5');
  formData.append('size', '1920*1080');
  formData.append('metadata', JSON.stringify({
    watermark: false,
    prompt_extend: true
  }));

  const response = await fetch('https://你的newapi服务器地址/v1/videos', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer sk-xxxx'
    },
    body: formData
  });

  const result = await response.json();
  return result.id;
}

// Aliyun Wanxiang Image-to-Video
async function generateAliImageToVideo() {
  const formData = new FormData();
  formData.append('prompt', '让这张图片动起来，添加自然的运动效果');
  formData.append('model', 'wan2.5-i2v-preview');
  formData.append('seconds', '3');
  formData.append('resolution', '720P');
  formData.append('input_reference', imageFile);
  formData.append('metadata', JSON.stringify({
    watermark: false,
    prompt_extend: true
  }));

  const response = await fetch('https://你的newapi服务器地址/v1/videos', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer sk-xxxx'
    },
    body: formData
  });

  const result = await response.json();
  return result.id;
}

// Aliyun Wanxiang Keyframe-to-Video
async function generateAliKeyframeVideo() {
  const formData = new FormData();
  formData.append('prompt', '从开始到结束的平滑过渡动画');
  formData.append('model', 'wan2.2-kf2v-flash');
  formData.append('seconds', '4');
  formData.append('metadata', JSON.stringify({
    first_frame_url: 'https://example.com/start.jpg',
    last_frame_url: 'https://example.com/end.jpg',
    resolution: '720P',
    watermark: false
  }));

  const response = await fetch('https://你的newapi服务器地址/v1/videos', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer sk-xxxx'
    },
    body: formData
  });

  const result = await response.json();
  return result.id;
}
```