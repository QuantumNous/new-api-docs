# Query Video

Query video generation task status and results by task ID

## API Endpoint

```
GET /v1/video/generations/{task_id}
```

## Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| task_id | string | Yes | Task ID |

## Request Example

```bash
curl 'https://your-newapi-server-address/v1/video/generations/{task_id}'
```

## Response Format

### 200 - Success Response

```json
{
  "error": {
    "code": 1,
    "message": "string"
  },
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

### Response Field Description

| Field | Type | Description |
|-------|------|-------------|
| task_id | string | Task ID |
| status | string | Task status (processing: in progress, succeeded: success, failed: failed) |
| format | string | Video format |
| url | string | Video resource URL (when successful) |
| metadata | object | Result metadata |
| error | object | Error information (when failed, null when successful) |

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


