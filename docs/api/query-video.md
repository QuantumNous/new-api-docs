# 查询视频 API

根据任务ID查询视频生成任务的状态和结果。

## 查询视频状态

### API 端点

```
GET /v1/video/generations/{task_id}
```

### 路径参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| task_id | string | 是 | 任务ID |

### 请求示例

```bash
curl 'https://你的newapi服务器地址/v1/video/generations/{task_id}' \
  -H "Authorization: Bearer sk-xxxx"
```

### 响应格式

#### 200 - 成功响应

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

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| task_id | string | 任务ID |
| status | string | 任务状态（processing: 处理中, succeeded: 成功, failed: 失败） |
| format | string | 视频格式 |
| url | string | 视频资源URL（成功时） |
| metadata | object | 结果元数据 |
| error | object | 错误信息（成功时为null） |

### 状态说明

| 状态 | 描述 |
|------|------|
| processing | 任务正在处理中 |
| queued | 任务已排队等待处理 |
| in_progress | 任务正在进行中 |
| succeeded | 任务成功完成 |
| failed | 任务失败 |

## OpenAI兼容格式查询

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

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务的唯一标识符 |
| object | string | 对象类型，固定为 "video" |
| model | string | 生成视频的模型名称 |
| status | string | 视频任务的当前生命周期状态 |
| progress | integer | 生成任务的近似完成百分比 |
| created_at | integer | 任务创建时的Unix时间戳（秒） |
| expires_at | integer | 可下载资源过期时的Unix时间戳（秒），如果已设置 |
| size | string | 生成视频的分辨率 |
| seconds | string | 生成视频片段的时长（秒） |
| quality | string | 视频质量 |
| url | string | 视频下载链接（完成时） |

## 获取视频内容

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

### 响应说明

直接返回视频文件流，Content-Type为 `video/mp4`

#### 响应头

| 字段 | 描述 |
|------|------|
| Content-Type | 视频文件类型，通常为 video/mp4 |
| Content-Length | 视频文件大小（字节） |
| Content-Disposition | 文件下载信息 |

## 错误响应

### 400 - 请求参数错误
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 401 - 未授权
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 403 - 无权限
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 404 - 任务不存在
```json
{
  "code": null,
  "message": "Task not found",
  "param": "task_id",
  "type": "invalid_request_error"
}
```

### 500 - 服务器内部错误
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

## 轮询策略

### 推荐轮询间隔

1. **初始轮询**: 提交任务后等待 2-3 秒再开始轮询
2. **轮询频率**: 
   - 前30秒: 每5秒轮询一次
   - 30秒-2分钟: 每10秒轮询一次
   - 2分钟后: 每30秒轮询一次
3. **超时处理**: 建议设置5-10分钟的总超时时间

### 轮询示例代码

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

## 最佳实践

1. **状态检查**: 定期检查任务状态，避免过度频繁的请求
2. **错误处理**: 妥善处理各种错误情况，包括网络错误和API错误
3. **超时设置**: 设置合理的超时时间，避免无限等待
4. **缓存策略**: 对于已完成的视频，可以考虑缓存结果
5. **并发控制**: 避免同时发起过多查询请求
6. **资源清理**: 及时下载并清理不需要的视频文件