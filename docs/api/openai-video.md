# OpenAI 视频格式

调用OpenAI视频生成接口生成视频，支持 Sora 等模型，也支持使用 OpenAI 视频格式调用可灵，即梦和 vidu。

## 生成视频

### API 端点

```
POST /v1/videos
```

### 请求头

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| Authorization | string | 是 | 用户认证令牌 (Bearer: sk-xxxx) |
| Content-Type | string | 是 | multipart/form-data |

### 请求参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| prompt | string | 是 | 描述要生成视频的文本提示词 |
| model | string | 否 | 视频生成模型，默认为 sora-2 |
| seconds | string | 否 | 视频时长（秒），默认为 4 秒 |
| size | string | 否 | 输出分辨率，格式为宽度x高度，默认为 720x1280 |
| input_reference | file | 否 | 可选图片参考，用于指导生成 |

### 请求示例

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=sora-2" \
  -F "prompt=A calico cat playing a piano on stage"
```

### 响应格式

#### 200 - 成功响应

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

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务ID |
| object | string | 对象类型，固定为 "video" |
| model | string | 使用的模型名称 |
| status | string | 任务状态（queued: 排队中, processing: 处理中, completed: 完成, failed: 失败） |
| progress | integer | 处理进度（0-100） |
| created_at | integer | 创建时间戳 |
| size | string | 视频分辨率 |
| seconds | string | 视频时长（秒） |
| quality | string | 视频质量 |

## 查询视频

根据任务ID查询视频生成任务的状态和结果

### API 端点

```
GET /v1/videos/{video_id}
```

### 路径参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| video_id | string | 是 | 视频任务ID |

### 请求示例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

### 响应格式

#### 200 - 成功响应

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

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务ID |
| object | string | 对象类型，固定为 "video" |
| model | string | 使用的模型名称 |
| status | string | 任务状态（queued: 排队中, processing: 处理中, completed: 完成, failed: 失败） |
| progress | integer | 处理进度（0-100） |
| created_at | integer | 创建时间戳 |
| size | string | 视频分辨率 |
| seconds | string | 视频时长（秒） |
| quality | string | 视频质量 |
| url | string | 视频下载链接（完成时） |

## 获取视频任务状态

根据任务ID获取视频生成任务的详细信息

### API 端点

```
GET /v1/videos/{video_id}
```

### 路径参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| video_id | string | 是 | 要获取的视频任务标识符 |

### 请求示例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

### 响应格式

#### 200 - 成功响应

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

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务的唯一标识符 |
| object | string | 对象类型，固定为 "video" |
| model | string | 生成视频的模型名称 |
| status | string | 视频任务的当前生命周期状态 |
| progress | integer | 生成任务的近似完成百分比 |
| created_at | integer | 任务创建时的Unix时间戳（秒） |
| completed_at | integer | 任务完成时的Unix时间戳（秒），如果已完成 |
| expires_at | integer | 可下载资源过期时的Unix时间戳（秒），如果已设置 |
| size | string | 生成视频的分辨率 |
| seconds | string | 生成视频片段的时长（秒） |
| quality | string | 视频质量 |
| remixed_from_video_id | string | 如果此视频是混音，则为源视频的标识符 |
| error | object | 如果生成失败，则包含错误信息的对象 |

## 获取视频内容

下载已完成的视频内容

### API 端点

```
GET /v1/videos/{video_id}/content
```

### 路径参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| video_id | string | 是 | 要下载的视频标识符 |

### 查询参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| variant | string | 否 | 要返回的可下载资源类型，默认为MP4视频 |

### 请求示例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

### 响应格式

#### 200 - 成功响应

直接返回视频文件流，Content-Type为 `video/mp4`

#### 响应头说明

| 字段 | 类型 | 描述 |
|------|------|------|
| Content-Type | string | 视频文件类型，通常为 video/mp4 |
| Content-Length | string | 视频文件大小（字节） |
| Content-Disposition | string | 文件下载信息 |

## 错误响应

### 400 - 请求参数错误
```json
{
  "error": {
    "message": "Invalid request parameters",
    "type": "invalid_request_error",
    "code": "invalid_parameter"
  }
}
```

### 401 - 未授权
```json
{
  "error": {
    "message": "Invalid API key",
    "type": "authentication_error",
    "code": "invalid_api_key"
  }
}
```

### 403 - 无权限
```json
{
  "error": {
    "message": "Insufficient permissions",
    "type": "permission_error",
    "code": "insufficient_permissions"
  }
}
```

### 429 - 请求频率限制
```json
{
  "error": {
    "message": "Rate limit exceeded",
    "type": "rate_limit_error",
    "code": "rate_limit_exceeded"
  }
}
```

### 500 - 服务器内部错误
```json
{
  "error": {
    "message": "Internal server error",
    "type": "server_error",
    "code": "internal_error"
  }
}
```
