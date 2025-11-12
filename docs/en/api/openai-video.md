# OpenAI Video Format

Call the OpenAI video generation interface to generate videos, supporting models like Sora, and also supporting the use of the OpenAI video format to call Keling, Jimeng, and Vidu.

## Generate Video

### API Endpoint

```
POST /v1/videos
```

### Request Headers

| Parameter | Type | Required | Description |
|------|------|------|------|
| Authorization | string | Yes | User authentication token (Bearer: sk-xxxx) |
| Content-Type | string | Yes | multipart/form-data |

### Request Parameters

| Parameter | Type | Required | Description |
|------|------|------|------|
| prompt | string | Yes | Text prompt describing the video to be generated |
| model | string | No | Video generation model, defaults to sora-2 |
| seconds | string | No | Video duration (seconds), defaults to 4 seconds |
| size | string | No | Output resolution, format is width x height, defaults to 720x1280 |
| input_reference | file | No | Optional image reference, used to guide generation |

### Request Example

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=sora-2" \
  -F "prompt=A calico cat playing a piano on stage"
```

### Response Format

#### 200 - Successful Response

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "status": "queued",
  "progress": 0,
  "created_at": 1712697600,
  "size": "1024x1808",
  "seconds": "8",
  "quality": "standard"
}
```

#### Response Field Description

| Field | Type | Description |
|------|------|------|
| id | string | Video Task ID |
| object | string | Object type, fixed as "video" |
| model | string | Name of the model used |
| status | string | Task status (queued: Queued, processing: Processing, completed: Completed, failed: Failed) |
| progress | integer | Processing progress (0-100) |
| created_at | integer | Creation timestamp |
| size | string | Video resolution |
| seconds | string | Video duration (seconds) |
| quality | string | Video quality |

## Query Video

Query the status and results of the video generation task based on the Task ID

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
  "status": "completed",
  "progress": 100,
  "created_at": 1712697600,
  "size": "1024x1808",
  "seconds": "8",
  "quality": "standard",
  "url": "https://example.com/video.mp4"
}
```

#### Response Field Description

| Field | Type | Description |
|------|------|------|
| id | string | Video Task ID |
| object | string | Object type, fixed as "video" |
| model | string | Name of the model used |
| status | string | Task status (queued: Queued, processing: Processing, completed: Completed, failed: Failed) |
| progress | integer | Processing progress (0-100) |
| created_at | integer | Creation timestamp |
| size | string | Video resolution |
| seconds | string | Video duration (seconds) |
| quality | string | Video quality |
| url | string | Video download link (when completed) |

## Get Video Task Status

Get detailed information about the video generation task based on the Task ID

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

#### 200 - Successful Response

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "status": "completed",
  "progress": 100,
  "created_at": 1712697600,
  "completed_at": 1712698000,
  "expires_at": 1712784400,
  "size": "1024x1808",
  "seconds": "8",
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
| model | string | Name of the model that generated the video |
| status | string | Current lifecycle status of the video task |
| progress | integer | Approximate completion percentage of the generation task |
| created_at | integer | Unix timestamp (seconds) when the task was created |
| completed_at | integer | Unix timestamp (seconds) when the task was completed, if finished |
| expires_at | integer | Unix timestamp (seconds) when the downloadable resource expires, if set |
| size | string | Resolution of the generated video |
| seconds | string | Duration of the generated video clip (seconds) |
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

### Response Format

#### 200 - Successful Response

Directly returns the video file stream, Content-Type is `video/mp4`

#### Response Header Description

| Field | Type | Description |
|------|------|------|
| Content-Type | string | Video file type, usually video/mp4 |
| Content-Length | string | Video file size (bytes) |
| Content-Disposition | string | File download information |

## Error Responses

### 400 - Invalid Request Parameters
```json
{
  "error": {
    "message": "Invalid request parameters",
    "type": "invalid_request_error",
    "code": "invalid_parameter"
  }
}
```

### 401 - Unauthorized
```json
{
  "error": {
    "message": "Invalid API key",
    "type": "authentication_error",
    "code": "invalid_api_key"
  }
}
```

### 403 - Insufficient Permissions
```json
{
  "error": {
    "message": "Insufficient permissions",
    "type": "permission_error",
    "code": "insufficient_permissions"
  }
}
```

### 429 - Rate Limit Exceeded
```json
{
  "error": {
    "message": "Rate limit exceeded",
    "type": "rate_limit_error",
    "code": "rate_limit_exceeded"
  }
}
```

### 500 - Internal Server Error
```json
{
  "error": {
    "message": "Internal server error",
    "type": "server_error",
    "code": "internal_error"
  }
}
```