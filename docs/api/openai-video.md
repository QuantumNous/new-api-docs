# OpenAI 视频格式（Sora格式）

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

### 请求参数 (multipart/form-data)

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| prompt | string | 是 | 描述要生成视频的文本提示词 |
| model | string | 否 | 视频生成模型，默认为 sora-2 |
| seconds | string | 否 | 视频时长（秒），默认为 4 秒 |
| size | string | 否 | 输出分辨率，格式为宽度x高度，默认为 720x1280 |
| input_reference | file | 否 | 输入图片文件（图生视频时使用） |
| metadata | string | 否 | 扩展参数（JSON字符串格式） |

#### metadata 参数说明

metadata 参数的作用是传递非sora模型特有的参数，比如阿里云万相的图片URL、水印、prompt智能改写等。metadata 参数的格式为 JSON 字符串，比如：
```json
{
  "img_url": "https://example.com/image.jpg",
  "watermark": false,
  "prompt_extend": true
}
```

### 请求示例

#### 文生视频 (仅文本提示)

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级" \
  -F "model=sora-2" \
  -F "seconds=5" \
  -F "size=1920x1080"
```

#### 图生视频 (文本提示 + 图片文件)

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=猫咪慢慢睁开眼睛，伸懒腰" \
  -F "model=sora-2" \
  -F "seconds=3" \
  -F "size=1920x1080" \
  -F "input_reference=@/path/to/cat.jpg"
```

#### 阿里云万相视频生成示例

##### 文生视频 (万相2.5)
```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=一只可爱的小猫在花园里玩耍，阳光明媚，色彩鲜艳" \
  -F "model=wan2.5-t2v-preview" \
  -F "seconds=5" \
  -F "size=1920*1080"
```

##### 图生视频 (万相2.5)
```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=让这张图片动起来，添加自然的运动效果" \
  -F "model=wan2.5-i2v-preview" \
  -F "seconds=5" \
  -F "size=1280P" \
  -F 'metadata={"img_url":"https://example.com/image.jpg"}'
```

### 响应格式

#### 201 - 创建成功

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

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务ID |
| object | string | 对象类型，固定为 "video" |
| model | string | 使用的模型名称 |
| created_at | integer | 创建时间戳 |
| status | string | 任务状态（processing: 处理中） |
| progress | integer | 生成进度百分比 |

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
  "created_at": 1640995200,
  "status": "succeeded",
  "progress": 100,
  "expires_at": 1641081600,
  "size": "1920x1080",
  "seconds": "5",
  "quality": "standard"
}
```

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务ID |
| object | string | 对象类型，固定为 "video" |
| model | string | 使用的模型名称 |
| created_at | integer | 创建时间戳 |
| status | string | 任务状态（processing: 处理中, succeeded: 成功, failed: 失败） |
| progress | integer | 生成进度百分比 |
| expires_at | integer | 资源过期时间戳 |
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
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 401 - 未授权
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 403 - 无权限
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 404 - 任务不存在
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 500 - 服务器内部错误
```json
{
  "error": {
    "message": "string",
    "type": "server_error"
  }
}
```

## 支持的模型

### OpenAI兼容
- `sora-2`: Sora视频生成模型

### 通过OpenAI格式调用的其他服务
- 阿里云万相 (Ali Wan): 使用 `wan2.5-t2v-preview` (文生视频), `wan2.5-i2v-preview` (图生视频), `wan2.2-i2v-flash`, `wan2.2-i2v-plus`, `wanx2.1-i2v-plus`, `wanx2.1-i2v-turbo`
- 可灵AI (Kling): 使用 `kling-v1`, `kling-v2-master`
- 即梦 (Jimeng): 使用 `jimeng_vgfm_t2v_l20`, `jimeng_vgfm_i2v_l20`
- Vidu: 使用 `viduq1`

## 阿里云万相特殊说明

### 支持的功能
- **文生视频 (t2v)**: 仅使用文本提示词生成视频
- **图生视频 (i2v)**: 使用文本提示词+图片生成视频
- **首尾帧生视频 (kf2v)**: 指定首帧和尾帧图片生成视频
- **音频生成 (s2v)**: 支持音频与视频结合

### 分辨率支持
- **480P**: 832×480, 480×832, 624×624
- **720P**: 1280×720, 720×1280, 960×960, 1088×832, 832×1088
- **1080P**: 1920×1080, 1080×1920, 1440×1440, 1632×1248, 1248×1632

### 特殊参数
- `watermark`: 是否添加水印（默认false）
- `prompt_extend`: 是否开启prompt智能改写（默认true）
- `audio`: 是否添加音频（仅wan2.5支持）
- `seed`: 随机数种子

### 模型特点
- **wan2.5-i2v-preview**: 万相2.5 preview版本，支持有声视频，推荐使用
- **wan2.2-i2v-flash**: 万相2.2极速版，生成速度快，无声视频
- **wan2.2-i2v-plus**: 万相2.2专业版，画质更高，无声视频
- **wanx2.1-i2v-plus**: 万相2.1专业版，稳定版本
- **wanx2.1-i2v-turbo**: 万相2.1极速版

## 最佳实践

1. **请求格式**: 使用 `multipart/form-data` 格式，这是OpenAI官方推荐的方式
2. **input_reference参数**: 用于图生视频功能，上传图片文件时使用 `@filename` 语法
3. **提示词优化**: 使用详细、具体的描述词，包含风格、质量要求
4. **参数设置**: 根据需求合理设置时长和分辨率
5. **阿里云万相特殊说明**:
   - **不支持直接上传文件**，所有资源通过URL传递
   - 使用 `metadata` 参数传递所有扩展参数（JSON字符串格式）
   - 图生视频使用 `metadata.img_url` 传递图片URL
   - 首尾帧生视频使用 `metadata.first_frame_url` 和 `metadata.last_frame_url`
6. **错误处理**: 实现适当的重试机制和错误处理
7. **异步处理**: 视频生成是异步任务，需要轮询查询状态
8. **资源管理**: 及时下载并清理不需要的视频文件

## JavaScript 示例

### 使用 FormData (推荐)

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

// 图生视频示例
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

### 阿里云万相调用示例

```javascript
// 阿里云万相文生视频
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

// 阿里云万相图生视频
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

// 阿里云万相首尾帧生视频
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