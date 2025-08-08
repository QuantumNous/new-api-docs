# 查询视频

根据任务ID查询视频生成任务的状态和结果

## API 端点

```
GET /v1/video/generations/{task_id}
```

## 路径参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| task_id | string | 是 | 任务ID |

## 请求示例

```bash
curl 'https://你的newapi服务器地址/v1/video/generations/{task_id}'
```

## 响应格式

### 200 - 成功响应

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

### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| task_id | string | 任务ID |
| status | string | 任务状态（processing: 处理中, succeeded: 成功, failed: 失败） |
| format | string | 视频格式 |
| url | string | 视频资源URL（成功时） |
| metadata | object | 结果元数据 |
| error | object | 错误信息（成功时为null） |

### 错误响应

#### 400 - 请求参数错误
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 401 - 未授权
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 403 - 无权限
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

#### 500 - 服务器内部错误
```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```


