# 生成视频

调用视频生成接口生成视频，支持多种视频生成服务：

- **可灵AI (Kling)**: [API文档](https://app.klingai.com/cn/dev/document-api/apiReference/commonInfo)
- **即梦 (Jimeng)**: [API文档](https://www.volcengine.com/docs/85621/1538636)

## API 端点

```
POST /v1/video/generations
```

## 请求头

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| Authorization | string | 是 | 用户认证令牌 (Bearer: sk-xxxx) |
| Content-Type | string | 是 | application/json |

## 请求参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| model | string | 是 | 模型/风格ID |
| prompt | string | 是 | 文本提示词 |
| duration | number | 否 | 视频时长（秒） |
| fps | integer | 否 | 视频帧率 |
| height | integer | 否 | 视频高度 |
| width | integer | 否 | 视频宽度 |
| image | string | 否 | 图片输入（URL/Base64） |
| metadata | object | 否 | 供应商特定/自定义参数（如 negative_prompt, style, quality_level 等） |
| n | integer | 否 | 生成视频数量 |
| response_format | string | 否 | 响应格式 |
| seed | integer | 否 | 随机种子 |
| user | string | 否 | 用户标识符 |

## 请求示例

### 可灵AI 示例

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

### 即梦AI 示例

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

### Vidu 渠道示例

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

## 响应格式

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
