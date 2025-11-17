# Query Video API

Query the status and results of a video generation task based on the Task ID.

## Query Video Status

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
curl 'https://你的newapi服务器地址/v1/video/generations/{task_id}' \
  -H "Authorization: Bearer sk-xxxx"
```

### Response Format

#### 200 - Success Response

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
  "url": "https://example.com/video.mp4"
}
```

#### Response Field Description

| Field | Type | Description |
|------|------|------|
| task_id | string | Task ID |
| status | string | Task status (processing: processing, succeeded: success, failed: failure) |
| format | string | Video format |
| url | string | Video resource URL (on success) |
| metadata | object | Result metadata |
| error | object | Error information (null on success) |

### Status Description

| Status | Description |
|------|------|
| processing | The task is currently being processed |
| queued | The task is queued awaiting processing |
| in_progress | The task is in progress |
| succeeded | The task completed successfully |
| failed | The task failed |

## OpenAI Compatible Format Query

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
  "url": "https://example.com/video.mp4"
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
| expires_at | integer | Unix timestamp (seconds) when the downloadable resource expires, if set |
| size | string | Resolution of the generated video |
| seconds | string | Duration of the generated video clip (seconds) |
| quality | string | Video quality |
| url | string | Video download link (upon completion) |

## Retrieve Video Content

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
| variant | string | No | The type of downloadable resource to return, defaults to MP4 video |

### Request Example

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

### Response Description

Directly returns the video file stream, with Content-Type as `video/mp4`

#### Response Headers

| Field | Description |
|------|------|
| Content-Type | Video file type, usually video/mp4 |
| Content-Length | Video file size (bytes) |
| Content-Disposition | File download information |

## Error Responses

### 400 - Invalid Request Parameters
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

### 404 - Task Not Found
```json
{
  "code": null,
  "message": "Task not found",
  "param": "task_id",
  "type": "invalid_request_error"
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

## Polling Strategy

### Recommended Polling Intervals

1. **Initial Polling**: Wait 2-3 seconds after submitting the task before starting to poll.
2. **Polling Frequency**: 
   - First 30 seconds: Poll once every 5 seconds.
   - 30 seconds to 2 minutes: Poll once every 10 seconds.
   - After 2 minutes: Poll once every 30 seconds.
3. **Timeout Handling**: It is recommended to set a total timeout of 5-10 minutes.

### Polling Example Code

```javascript
async function pollVideoStatus(taskId, maxAttempts = 30) {
  const baseUrl = 'https://你的newapi服务器地址';
  const headers = {
    'Authorization': 'Bearer sk-xxxx',
    'Content-Type': 'application/json'
  };

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      const response = await fetch(`${baseUrl}/v1/video/generations/${taskId}`, {
        headers
      });
      
      const result = await response.json();
      
      if (result.status === 'succeeded') {
        return result;
      } else if (result.status === 'failed') {
        throw new Error(`Video generation failed: ${result.error?.message || 'Unknown error'}`);
      }
      
      // 等待后重试
      const delay = attempt < 6 ? 5000 : (attempt < 12 ? 10000 : 30000);
      await new Promise(resolve => setTimeout(resolve, delay));
      
    } catch (error) {
      console.error(`Attempt ${attempt + 1} failed:`, error);
      if (attempt === maxAttempts - 1) {
        throw error;
      }
    }
  }
  
  throw new Error('Max polling attempts reached');
}
```

## Best Practices

1. **Status Check**: Regularly check the task status to avoid overly frequent requests.
2. **Error Handling**: Properly handle various error conditions, including network errors and API errors.
3. **Timeout Setting**: Set a reasonable timeout period to avoid infinite waiting.
4. **Caching Strategy**: Consider caching results for completed videos.
5. **Concurrency Control**: Avoid initiating too many query requests simultaneously.
6. **Resource Cleanup**: Download and promptly clean up unnecessary video files.