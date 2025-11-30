# OpenAI Image Format (Image)

!!! info "Official Documentation"
    [OpenAI Images](https://platform.openai.com/docs/api-reference/images)

## 📝 Introduction

Given a text prompt and/or input image, the model will generate new images. OpenAI offers several powerful image generation models that can create, edit, and modify images based on natural language descriptions. Currently supported models include:

| Model | Description |
| --- | --- |
| **DALL·E Series** | Includes two versions, DALL·E 2 and DALL·E 3, which differ significantly in image quality, creative expression, and accuracy |
| **GPT-Image-1** | OpenAI's latest image model, supporting multi-image editing features, capable of creating new composite images based on multiple input images |

## 💡 Request Examples

### Create Image ✅

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

**Response Example:**

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

### Edit Image ✅

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

**Response Example (dall-e-2):**

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

**Response Example (gpt-image-1):**

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

### Generate Image Variations ✅

```bash
curl https://你的newapi服务器地址/v1/images/variations \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F image="@otter.png" \
  -F n=2 \
  -F size="1024x1024"
```

**Response Example:**

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

## 📮 Request

### Endpoints

#### Create Image
```
POST /v1/images/generations
```

Creates an image given a text prompt.

#### Edit Image
```
POST /v1/images/edits
```

Creates an edited or extended image based on one or more original images and a prompt. This endpoint supports the dall-e-2 and gpt-image-1 models.

#### Generate Variation
```
POST /v1/images/variations
```

Creates a variation of a given image.

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$OPENAI_API_KEY` is your API key.

### Request Body Parameters

#### Create Image

##### `prompt`
- Type: string
- Required: Yes
- Description: A text description of the desired image(s).
  - dall-e-2 maximum length is 1000 characters
  - dall-e-3 maximum length is 4000 characters
- Tips:
  - Use specific and detailed descriptions
  - Include key visual elements
  - Specify the desired artistic style
  - Describe composition and perspective

##### `model`
- Type: string
- Required: No
- Default: dall-e-2
- Description: The model to use for image generation.

##### `n`
- Type: integer or null
- Required: No
- Default: 1
- Description: The number of images to generate. Must be between 1 and 10. dall-e-3 only supports n=1.

##### `quality`
- Type: string
- Required: No
- Default: standard
- Description: The quality of the generated image. The hd option generates more detailed and consistent images. This parameter is only supported by dall-e-3.

##### `response_format`
- Type: string or null
- Required: No
- Default: url
- Description: The format in which the generated images are returned. Must be one of url or b64_json. URLs are valid for 60 minutes after generation.

##### `size`
- Type: string or null
- Required: No
- Default: 1024x1024
- Description: The size of the generated images. dall-e-2 must be one of 256x256, 512x512, or 1024x1024. dall-e-3 must be one of 1024x1024, 1792x1024, or 1024x1792.

##### `style`
- Type: string or null
- Required: No
- Default: vivid
- Description: The style of the generated images. Must be one of vivid or natural. vivid tends to generate hyper-real and dramatic images, while natural tends to generate more natural, less hyper-real images. This parameter is only supported by dall-e-3.

##### `user`
- Type: string
- Required: No
- Description: A unique identifier representing your end-user, which can help OpenAI monitor and detect abuse.

#### `moderation`
- Type: string
- Required: No
- Default: auto
- Description: auto: Standard moderation, designed to limit the generation of certain content categories that may not be age-appropriate. low: Less restrictive moderation.

#### Edit Image

##### `image`
- Type: file or file array
- Required: Yes
- Description: The image to be edited.
  - For dall-e-2: Must be a valid PNG file, less than 4MB, and square. If no mask is provided, the image must have transparency, which will be used as the mask.
  - For gpt-image-1: Multiple images can be provided as an array. Each image should be a PNG, WEBP, or JPG file, less than 25MB.

##### `prompt`
- Type: string
- Required: Yes
- Description: A text description of the desired image(s).
  - dall-e-2 maximum length is 1000 characters
  - gpt-image-1 maximum length is 32000 characters

##### `mask`
- Type: file
- Required: No
- Description: An additional image whose fully transparent areas (e.g., alpha zero areas) indicate where the image should be edited. If multiple images are provided, the mask will be applied to the first image. Must be a valid PNG file, less than 4MB, and have the same dimensions as the image.

##### `model`
- Type: string
- Required: No
- Default: dall-e-2
- Description: The model to use for image generation. Supports dall-e-2 and gpt-image-1. Defaults to dall-e-2 unless gpt-image-1 specific parameters are used.

##### `quality`
- Type: string or null
- Required: No
- Default: auto
- Description: The quality of the generated image.
  - gpt-image-1 supports high, medium, and low
  - dall-e-2 only supports standard
  - Defaults to auto

##### `size`
- Type: string or null
- Required: No
- Default: 1024x1024
- Description: The size of the generated images.
  - gpt-image-1 must be one of 1024x1024, 1536x1024 (landscape), 1024x1536 (portrait), or auto (default)
  - dall-e-2 must be one of 256x256, 512x512, or 1024x1024

Other parameters are the same as the Create Image interface.

#### Generate Variations

##### `image`
- Type: file
- Required: Yes
- Description: The image to use as the basis for the variation(s). Must be a valid PNG file, less than 4MB, and square.

Other parameters are the same as the Create Image interface.

## 📥 Response

### Successful Response

All three endpoints return a response containing a list of image objects.

#### `created`
- Type: integer
- Description: The timestamp when the response was created

#### `data`
- Type: array
- Description: A list of generated image objects

#### `usage` (Only applicable to gpt-image-1)
- Type: object
- Description: Token usage for the API call
  - `total_tokens`: Total tokens used
  - `input_tokens`: Tokens used for input
  - `output_tokens`: Tokens used for output
  - `input_tokens_details`: Detailed information on input tokens (text tokens and image tokens)

### Image Object

#### `b64_json`
- Type: string
- Description: If `response_format` is `b64_json`, this contains the base64 encoded JSON of the generated image

#### `url`
- Type: string
- Description: If `response_format` is `url` (default), this contains the URL of the generated image

#### `revised_prompt`
- Type: string
- Description: If the prompt was modified, this contains the revised prompt used to generate the image

Example Image Object:
```json
{
  "url": "https://...",
  "revised_prompt": "一只可爱的小海獭在水中嬉戏,它有着圆圆的眼睛和毛茸茸的皮毛"
}
```

## 🌟 Best Practices

### Prompt Writing Suggestions

1. Use clear and specific descriptions
2. Specify important visual details
3. Describe the desired artistic style and atmosphere
4. Include instructions for composition and perspective

### Parameter Selection Suggestions

1. Model Selection
   - dall-e-3: Suitable for scenarios requiring high quality and precise details
   - dall-e-2: Suitable for rapid prototyping or simple image generation

2. Size Selection
   - 1024x1024: Best choice for general scenarios
   - 1792x1024/1024x1792: Suitable for landscape/portrait scenarios
   - Smaller sizes: Suitable for thumbnails or quick previews

3. Quality and Style
   - quality=hd: Used for images requiring fine detail
   - style=vivid: Suitable for creative and artistic effects
   - style=natural: Suitable for realistic scene reproduction

### Common Issues

1. Image generation failure
   - Check if the prompt complies with content policies
   - Confirm file format and size limits
   - Verify API key permissions

2. Results do not match expectations
   - Optimize the prompt description
   - Adjust quality and style parameters
   - Consider using image editing or variation features