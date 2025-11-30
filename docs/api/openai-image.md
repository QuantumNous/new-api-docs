# OpenAI 图像格式（Image）

!!! info "官方文档"
    [OpenAI Images](https://platform.openai.com/docs/api-reference/images)

## 📝 简介

给定文本提示和/或输入图片，模型将生成新的图片。OpenAI 提供多种强大的图像生成模型，可以根据自然语言描述创建、编辑和修改图像。目前支持的模型包括：

| 模型 | 描述 |
| --- | --- |
| **DALL·E 系列** | 包括 DALL·E 2 和 DALL·E 3 两个版本，它们在图像质量、创意表现和精确度上都有显著差异 |
| **GPT-Image-1** | OpenAI最新图片模型，支持多图片编辑功能，能够基于多个输入图像创建新的组合图像 |

## 💡 请求示例

### 创建图片 ✅

```bash
# 基础图片生成
curl https://你的newapi服务器地址/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的小海獭",
    "n": 1,
    "size": "1024x1024"
  }'

# 高质量图片生成
curl https://你的newapi服务器地址/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的小海獭",
    "quality": "hd",
    "style": "vivid",
    "size": "1024x1024"
  }'

# 使用 base64 返回格式
curl https://你的newapi服务器地址/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的小海獭",
    "response_format": "b64_json"
  }'
```

**响应示例:**

```json
{
  "created": 1589478378,
  "data": [
    {
      "url": "https://...",
      "revised_prompt": "一只可爱的小海獭在水中嬉戏,它有着圆圆的眼睛和毛茸茸的皮毛"
    }
  ]
}
```

### 编辑图片 ✅

```bash
# dall-e-2 图片编辑
curl https://你的newapi服务器地址/v1/images/edits \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F image="@otter.png" \
  -F mask="@mask.png" \
  -F prompt="一只戴着贝雷帽的可爱小海獭" \
  -F n=2 \
  -F size="1024x1024"

# gpt-image-1 多图片编辑示例
curl https://你的newapi服务器地址/v1/images/edits \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F "model=gpt-image-1" \
  -F "image[]=@body-lotion.png" \
  -F "image[]=@bath-bomb.png" \
  -F "image[]=@incense-kit.png" \
  -F "image[]=@soap.png" \
  -F "prompt=创建一个包含这四个物品的精美礼品篮" \
  -F "quality=high"
```

**响应示例 (dall-e-2):**

```json
{
  "created": 1589478378,
  "data": [
    {
      "url": "https://..."
    },
    {
      "url": "https://..."
    }
  ]
}
```

**响应示例 (gpt-image-1):**

```json
{
  "created": 1713833628,
  "data": [
    {
      "b64_json": "..."
    }
  ],
  "usage": {
    "total_tokens": 100,
    "input_tokens": 50,
    "output_tokens": 50,
    "input_tokens_details": {
      "text_tokens": 10,
      "image_tokens": 40
    }
  }
}
```

### 生成图片变体 ✅

```bash
curl https://你的newapi服务器地址/v1/images/variations \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F image="@otter.png" \
  -F n=2 \
  -F size="1024x1024"
```

**响应示例:**

```json
{
  "created": 1589478378,
  "data": [
    {
      "url": "https://..."
    },
    {
      "url": "https://..."
    }
  ]
}
```

## 📮 请求

### 端点

#### 创建图片
```
POST /v1/images/generations
```

根据文本提示创建图片。

#### 编辑图片
```
POST /v1/images/edits
```

根据一个或多个原始图片和提示创建编辑或扩展的图片。此端点支持 dall-e-2 和 gpt-image-1 模型。

#### 生成变体
```
POST /v1/images/variations
```

创建给定图片的变体。

### 鉴权方法

在请求头中包含以下内容进行 API 密钥认证：

```
Authorization: Bearer $NEWAPI_API_KEY
```

其中 `$OPENAI_API_KEY` 是您的 API 密钥。

### 请求体参数

#### 创建图片

##### `prompt`
- 类型：字符串
- 必需：是
- 说明：期望生成图片的文本描述。
  - dall-e-2 最大长度为 1000 字符
  - dall-e-3 最大长度为 4000 字符
- 提示：
  - 使用具体和详细的描述
  - 包含关键的视觉元素
  - 指定期望的艺术风格
  - 描述构图和视角

##### `model`
- 类型：字符串
- 必需：否
- 默认值：dall-e-2
- 说明：用于图像生成的模型。

##### `n`
- 类型：整数或 null
- 必需：否
- 默认值：1
- 说明：要生成的图片数量。必须在 1-10 之间。dall-e-3 仅支持 n=1。

##### `quality`
- 类型：字符串
- 必需：否
- 默认值：standard
- 说明：生成图片的质量。hd 选项会生成更细致和一致的图片。仅 dall-e-3 支持此参数。

##### `response_format`
- 类型：字符串或 null
- 必需：否
- 默认值：url
- 说明：返回生成图片的格式。必须是 url 或 b64_json 之一。URL 在生成后 60 分钟内有效。

##### `size`
- 类型：字符串或 null
- 必需：否
- 默认值：1024x1024
- 说明：生成图片的尺寸。dall-e-2 必须是 256x256、512x512 或 1024x1024 之一。dall-e-3 必须是 1024x1024、1792x1024 或 1024x1792 之一。

##### `style`
- 类型：字符串或 null
- 必需：否
- 默认值：vivid
- 说明：生成图片的风格。必须是 vivid 或 natural 之一。vivid 倾向于生成超现实和戏剧性的图片，natural 倾向于生成更自然、不那么超现实的图片。仅 dall-e-3 支持此参数。

##### `user`
- 类型：字符串
- 必需：否
- 说明：代表最终用户的唯一标识符，可帮助 OpenAI 监控和检测滥用行为。

#### `moderation`
- 类型：字符串
- 必需：否
- 默认值：auto
- 说明：auto：标准审核，旨在限制生成某些可能不适合年龄的内容类别。low：限制较少的审核。

#### 编辑图片

##### `image`
- 类型：文件或文件数组
- 必需：是
- 说明：要编辑的图片。
  - 对于 dall-e-2：必须是有效的 PNG 文件，小于 4MB，且为正方形。如果未提供 mask，图片必须具有透明度，这将用作蒙版。
  - 对于 gpt-image-1：可以提供多个图片作为数组，每个图片应为 PNG、WEBP 或 JPG 文件，小于 25MB。

##### `prompt`
- 类型：字符串
- 必需：是
- 说明：期望生成图片的文本描述。
  - dall-e-2 最大长度为 1000 字符
  - gpt-image-1 最大长度为 32000 字符

##### `mask`
- 类型：文件
- 必需：否
- 说明：额外的图片，其完全透明区域（如 alpha 为零的区域）指示应该编辑的位置。如果提供了多个图片，mask 将应用于第一张图片。必须是有效的 PNG 文件，小于 4MB，且与 image 具有相同尺寸。

##### `model`
- 类型：字符串
- 必需：否
- 默认值：dall-e-2
- 说明：用于图像生成的模型。支持 dall-e-2 和 gpt-image-1。除非使用了 gpt-image-1 特有的参数，否则默认为 dall-e-2。

##### `quality`
- 类型：字符串或 null
- 必需：否
- 默认值：auto
- 说明：生成图片的质量。
  - gpt-image-1 支持 high、medium 和 low
  - dall-e-2 仅支持 standard
  - 默认为 auto

##### `size`
- 类型：字符串或 null
- 必需：否
- 默认值：1024x1024
- 说明：生成图片的尺寸。
  - gpt-image-1 必须是 1024x1024、1536x1024（横版）、1024x1536（竖版）或 auto（默认）之一
  - dall-e-2 必须是 256x256、512x512 或 1024x1024 之一

其他参数与创建图片接口相同。

#### 生成变体

##### `image`
- 类型：文件
- 必需：是
- 说明：作为变体基础的图片。必须是有效的 PNG 文件，小于 4MB，且为正方形。

其他参数与创建图片接口相同。

## 📥 响应

### 成功响应

所有三个端点都返回包含图片对象列表的响应。

#### `created`
- 类型：整数
- 说明：响应创建的时间戳

#### `data`
- 类型：数组
- 说明：生成的图片对象列表

#### `usage`（仅适用于 gpt-image-1）
- 类型：对象
- 说明：API 调用的令牌使用情况
  - `total_tokens`：使用的总令牌数
  - `input_tokens`：输入使用的令牌数
  - `output_tokens`：输出使用的令牌数
  - `input_tokens_details`：输入令牌的详细信息（文本令牌和图像令牌）

### 图片对象

#### `b64_json`
- 类型：字符串
- 说明：如果 response_format 为 b64_json，则包含生成图片的 base64 编码 JSON

#### `url`
- 类型：字符串
- 说明：如果 response_format 为 url（默认），则包含生成图片的 URL

#### `revised_prompt`
- 类型：字符串
- 说明：如果提示有任何修改，则包含用于生成图片的修改后的提示

示例图片对象:
```json
{
  "url": "https://...",
  "revised_prompt": "一只可爱的小海獭在水中嬉戏,它有着圆圆的眼睛和毛茸茸的皮毛"
}
```

## 🌟 最佳实践

### Prompt 编写建议

1. 使用清晰具体的描述
2. 指定重要的视觉细节
3. 描述期望的艺术风格和氛围
4. 注意构图和视角的说明

### 参数选择建议

1. 模型选择
   - dall-e-3：适合需要高质量、精确细节的场景
   - dall-e-2：适合快速原型或简单图像生成

2. 尺寸选择
   - 1024x1024：通用场景的最佳选择
   - 1792x1024/1024x1792：适合横版/竖版场景
   - 较小尺寸：适合缩略图或快速预览

3. 质量和风格
   - quality=hd：用于需要精细细节的图像
   - style=vivid：适合创意和艺术效果
   - style=natural：适合真实场景再现

### 常见问题

1. 图片生成失败
   - 检查 prompt 是否符合内容政策
   - 确认文件格式和大小限制
   - 验证 API 密钥权限

2. 结果与预期不符
   - 优化 prompt 描述
   - 调整质量和风格参数
   - 考虑使用图片编辑或变体功能 
