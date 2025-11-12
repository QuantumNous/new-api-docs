# OpenAI Image Format (Image)

!!! info "Official Documentation"
    [OpenAI Images](https://platform.openai.com/docs/api-reference/images)

## 📝 Introduction

Given a text prompt and/or input image, the model will generate new images. OpenAI provides multiple powerful image generation models that can create, edit, and modify images based on natural language descriptions. Currently supported models include:

| Model | Description |
| --- | --- |
| **DALL·E Series** | Includes DALL·E 2 and DALL·E 3 versions, which have significant differences in image quality, creative expression, and precision |
| **GPT-Image-1** | OpenAI's latest image model, supporting multi-image editing capabilities, able to create new composite images based on multiple input images |

## 💡 Request Examples

### Create Image ✅

```bash
# Basic image generation
curl https://your-newapi-server-address/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "A cute little sea otter",
    "n": 1,
    "size": "1024x1024"
  }'

# High-quality image generation
curl https://your-newapi-server-address/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "A cute little sea otter",
    "quality": "hd",
    "style": "vivid",
    "size": "1024x1024"
  }'

# Using base64 response format
curl https://your-newapi-server-address/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "A cute little sea otter",
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
      "revised_prompt": "A cute little sea otter playing in the water, with round eyes and fluffy fur"
    }
  ]
}
```

### Edit Image ✅

```bash
# dall-e-2 image editing
curl https://your-newapi-server-address/v1/images/edits \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F image="@otter.png" \
  -F mask="@mask.png" \
  -F prompt="A cute little sea otter wearing a beret" \
  -F n=2 \
  -F size="1024x1024"

# gpt-image-1 multi-image editing example
curl https://your-newapi-server-address/v1/images/edits \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F "model=gpt-image-1" \
  -F "image[]=@body-lotion.png" \
  -F "image[]=@bath-bomb.png" \
  -F "image[]=@incense-kit.png" \
  -F "image[]=@soap.png" \
  -F "prompt=Create an elegant gift basket containing these four items" \
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
curl https://your-newapi-server-address/v1/images/variations \
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

Create images based on text prompts.

#### Edit Image
```
POST /v1/images/edits
```

Create edited or extended images based on one or more original images and prompts. This endpoint supports both dall-e-2 and gpt-image-1 models.

#### Generate Variations
```
POST /v1/images/variations
```

Create variations of a given image.

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key.

### Request Body Parameters

#### Create Image

##### `prompt`
- Type: String
- Required: Yes
- Description: Text description of the desired image to generate.
  - dall-e-2 maximum length is 1000 characters
  - dall-e-3 maximum length is 4000 characters
- Tips:
  - Use specific and detailed descriptions
  - Include key visual elements
  - Specify expected artistic style
  - Describe composition and perspective

##### `model`
- Type: String
- Required: No
- Default: dall-e-2
- Description: Model used for image generation.

##### `n`
- Type: Integer or null
- Required: No
- Default: 1
- Description: Number of images to generate. Must be between 1-10. dall-e-3 only supports n=1.

##### `quality`
- Type: String
- Required: No
- Default: standard
- Description: Quality of the generated image. hd option will generate more detailed and consistent images. Only dall-e-3 supports this parameter.

##### `response_format`
- Type: String or null
- Required: No
- Default: url
- Description: Format of the generated image to return. Must be url or b64_json. URL is valid for 60 minutes after generation.

##### `size`
- Type: String or null
- Required: No
- Default: 1024x1024
- Description: Size of the generated image. dall-e-2 must be one of 256x256, 512x512, or 1024x1024. dall-e-3 must be one of 1024x1024, 1792x1024, or 1024x1792.

##### `style`
- Type: String or null
- Required: No
- Default: vivid
- Description: Style of the generated image. Must be vivid or natural. Vivid tends to generate surreal and dramatic images, while natural tends to generate more natural, less surreal images. Only dall-e-3 supports this parameter.

##### `user`
- Type: String
- Required: No
- Description: Unique identifier for the end user, which can help OpenAI monitor and detect abuse.

#### Edit Image

##### `image`
- Type: File or file array
- Required: Yes
- Description: Image to edit.
  - For dall-e-2: Must be a valid PNG file, less than 4MB, and square. If no mask is provided, the image must have transparency, which will be used as a mask.
  - For gpt-image-1: Multiple images can be provided as an array, each image should be a PNG, WEBP, or JPG file, less than 25MB.

##### `prompt`
- Type: String
- Required: Yes
- Description: Text description of the desired image to generate.
  - dall-e-2 maximum length is 1000 characters
  - gpt-image-1 maximum length is 32000 characters

##### `mask`
- Type: File
- Required: No
- Description: Additional image, whose fully transparent areas (e.g., areas with alpha zero) indicate the positions to be edited. If multiple images are provided, the mask will be applied to the first image. Must be a valid PNG file, less than 4MB, and the same size as the image.

##### `model`
- Type: String
- Required: No
- Default: dall-e-2
- Description: Model used for image generation. Supports dall-e-2 and gpt-image-1. If gpt-image-1 specific parameters are not used, it defaults to dall-e-2.

##### `quality`
- Type: String or null
- Required: No
- Default: auto
- Description: Quality of the generated image.
  - gpt-image-1 supports high, medium, and low
  - dall-e-2 only supports standard
  - Defaults to auto

##### `size`
- Type: String or null
- Required: No
- Default: 1024x1024
- Description: Size of the generated image.
  - gpt-image-1 must be one of 1024x1024, 1536x1024 (horizontal), 1024x1536 (vertical), or auto (default)
  - dall-e-2 must be one of 256x256, 512x512, or 1024x1024

Other parameters are the same as the Create Image interface.

#### Generate Variations

##### `image`
- Type: File
- Required: Yes
- Description: Image to be used as the basis for variations. Must be a valid PNG file, less than 4MB, and square.

Other parameters are the same as the Create Image interface.

## 📥 Response

### Successful Response

All three endpoints return a response containing a list of image objects.

#### `created`
- Type: Integer
- Description: Timestamp of the response creation

#### `data`
- Type: Array
- Description: List of generated image objects

#### `usage` (only for gpt-image-1)
- Type: Object
- Description: Token usage for the API call
  - `total_tokens`: Total tokens used
  - `input_tokens`: Tokens used for input
  - `output_tokens`: Tokens used for output
  - `input_tokens_details`: Detailed information about input tokens (text tokens and image tokens)

### Image Object

#### `b64_json`
- Type: String
- Description: If response_format is b64_json, it contains the base64 encoded JSON of the generated image

#### `url`
- Type: String
- Description: If response_format is url (default), it contains the URL of the generated image

#### `revised_prompt`
- Type: String
- Description: If the prompt was modified, it contains the modified prompt used for image generation

Example image object:
```json
{
  "url": "https://...",
  "revised_prompt": "A cute little sea otter playing in the water, with round eyes and fluffy fur"
}
```

## 🌟 Best Practices

### Prompt Writing Tips

1. Use clear and specific descriptions
2. Specify important visual details
3. Describe expected artistic style and atmosphere
4. Pay attention to composition and perspective instructions

### Parameter Selection Tips

1. Model Selection
   - dall-e-3: Suitable for scenes requiring high quality and precise details
   - dall-e-2: Suitable for quick prototypes or simple image generation

2. Size Selection
   - 1024x1024: General scene best choice
   - 1792x1024/1024x1792: Suitable for horizontal/vertical scenes
   - Smaller sizes: Suitable for thumbnails or quick previews

3. Quality and Style
   - quality=hd: For images requiring fine details
   - style=vivid: Suitable for creative and artistic effects
   - style=natural: Suitable for realistic scene reproduction

### Common Questions

1. Image generation failed
   - Check if the prompt complies with content policies
   - Confirm file format and size limits
   - Verify API key permissions

2. Results do not match expectations
   - Optimize prompt description
   - Adjust quality and style parameters
   - Consider using image editing or variation features 