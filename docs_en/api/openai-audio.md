# OpenAI Audio Format

!!! info "Official Documentation"
    [OpenAI Audio](https://platform.openai.com/docs/api-reference/audio)

## 📝 Introduction

OpenAI Audio API provides three main functions:

1. Text-to-Speech (TTS) - Convert text to natural speech
2. Speech-to-Text (STT) - Transcribe audio to text
3. Audio Translation - Translate non-English audio to English text

## 💡 Request Examples

### Text-to-Speech ✅

```bash
curl https://your-newapi-server-address/v1/audio/speech \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "tts-1",
    "input": "Hello, world!",
    "voice": "alloy"
  }' \
  --output speech.mp3
```

### Speech-to-Text ✅

```bash
curl https://your-newapi-server-address/v1/audio/transcriptions \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/file/audio.mp3" \
  -F model="whisper-1"
```

**Response Example:**

```json
{
  "text": "Hello, world!"
}
```

### Audio Translation ✅

```bash
curl https://your-newapi-server-address/v1/audio/translations \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/file/chinese.mp3" \
  -F model="whisper-1"
```

**Response Example:**

```json
{
  "text": "Hello, world!"
}
```

## 📮 Request

### Endpoints

#### Text-to-Speech
```
POST /v1/audio/speech
```

Convert text to speech.

#### Speech-to-Text
```
POST /v1/audio/transcriptions
```

Transcribe audio to text in the input language.

#### Audio Translation
```
POST /v1/audio/translations
```

Translate audio to English text.

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key.

### Request Body Parameters

#### Text-to-Speech

##### `model`
- Type: String
- Required: Yes
- Optional values: tts-1, tts-1-hd
- Description: TTS model to use

##### `input`
- Type: String  
- Required: Yes
- Maximum length: 4096 characters
- Description: Text to convert to speech

##### `voice`
- Type: String
- Required: Yes
- Optional values: alloy, echo, fable, onyx, nova, shimmer
- Description: Voice to use when generating speech

##### `response_format`
- Type: String
- Required: No
- Default: mp3
- Optional values: mp3, opus, aac, flac, wav, pcm
- Description: Audio output format

##### `speed`
- Type: Number
- Required: No
- Default: 1.0
- Range: 0.25 - 4.0
- Description: Speed of generated speech

#### Speech-to-Text

##### `file`
- Type: File
- Required: Yes
- Supported formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, webm
- Description: Audio file to transcribe

##### `model`
- Type: String
- Required: Yes
- Currently only supports: whisper-1
- Description: Model ID to use

##### `language`
- Type: String
- Required: No
- Format: ISO-639-1 (e.g., "en")
- Description: Language of the audio, providing this can improve accuracy

##### `prompt`
- Type: String
- Required: No
- Description: Text to guide the model's style or continue from a previous audio segment

##### `response_format`
- Type: String
- Required: No
- Default: json
- Optional values: json, text, srt, verbose_json, vtt
- Description: Output format

##### `temperature`
- Type: Number
- Required: No
- Default: 0
- Range: 0 - 1
- Description: Sampling temperature, higher values make output more random

##### `timestamp_granularities`
- Type: Array
- Required: No
- Default: segment
- Optional values: word, segment
- Description: Granularity of transcription timestamps

#### Audio Translation

##### `file`
- Type: File
- Required: Yes
- Supported formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, webm
- Description: Audio file to translate

##### `model`
- Type: String
- Required: Yes
- Currently only supports: whisper-1
- Description: Model ID to use

##### `prompt`
- Type: String
- Required: No
- Description: English text to guide the model's style

##### `response_format`
- Type: String
- Required: No
- Default: json
- Optional values: json, text, srt, verbose_json, vtt
- Description: Output format

##### `temperature`
- Type: Number
- Required: No
- Default: 0
- Range: 0 - 1
- Description: Sampling temperature, higher values make output more random

## 📥 Response

### Successful Response

#### Text-to-Speech

Returns binary audio file content.

#### Speech-to-Text

##### Basic JSON Format

```json
{
  "text": "Transcribed text content"
}
```

##### Detailed JSON Format

```json
{
  "task": "transcribe",
  "language": "english",
  "duration": 8.47,
  "text": "Complete transcribed text",
  "segments": [
    {
      "id": 0,
      "seek": 0,
      "start": 0.0,
      "end": 3.32,
      "text": "Segmented transcribed text",
      "tokens": [50364, 440, 7534],
      "temperature": 0.0,
      "avg_logprob": -0.286,
      "compression_ratio": 1.236,
      "no_speech_prob": 0.009
    }
  ]
}
```

#### Audio Translation

```json
{
  "text": "Translated English text"
}
```

### Error Response

When a request encounters an issue, the API will return an error response object, with HTTP status codes in the 4XX-5XX range.

#### Common Error Status Codes

- `400 Bad Request`: Invalid request parameters
- `401 Unauthorized`: Invalid API key or not provided
- `429 Too Many Requests`: Exceeded API call limit
- `500 Internal Server Error`: Server internal error

Error response example:

```json
{
  "error": {
    "message": "Unsupported file format",
    "type": "invalid_request_error",
    "param": "file",
    "code": "invalid_file_format"
  }
}
``` 