# OpenAI オーディオフォーマット

!!! info "公式ドキュメント"
    [OpenAI Audio](https://platform.openai.com/docs/api-reference/audio)

## 📝 概要

OpenAI オーディオ API は、主に以下の3つの機能を提供します。

1. テキスト読み上げ (TTS) - テキストを自然な音声に変換します
2. 音声認識 (STT) - 音声をテキストに書き起こします
3. 音声翻訳 - 英語以外の音声を英語のテキストに翻訳します

## 💡 リクエスト例

### テキスト読み上げ ✅

```bash
curl https://你的newapi服务器地址/v1/audio/speech \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "tts-1",
    "input": "你好,世界!",
    "voice": "alloy"
  }' \
  --output speech.mp3
```

### 音声認識 ✅

```bash
curl https://你的newapi服务器地址/v1/audio/transcriptions \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/file/audio.mp3" \
  -F model="whisper-1"
```

**レスポンス例:**

```json
{
  "text": "你好,世界!"
}
```

### 音声翻訳 ✅

```bash
curl https://你的newapi服务器地址/v1/audio/translations \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/file/chinese.mp3" \
  -F model="whisper-1"
```

**レスポンス例:**

```json
{
  "text": "Hello, world!"
}
```

## 📮 リクエスト

### エンドポイント

#### テキスト読み上げ
```
POST /v1/audio/speech
```

テキストを音声に変換します。

#### 音声認識
```
POST /v1/audio/transcriptions
```

音声を入力言語のテキストに書き起こします。

#### 音声翻訳
```
POST /v1/audio/translations
```

音声を英語のテキストに翻訳します。

### 認証方法

リクエストヘッダーに以下を含めて API キー認証を行います。

```
Authorization: Bearer $NEWAPI_API_KEY
```

ここで `$NEWAPI_API_KEY` はお客様の API キーです。

### リクエストボディパラメータ

#### テキスト読み上げ

##### `model`
- タイプ：文字列
- 必須：はい
- 選択可能な値：tts-1, tts-1-hd
- 説明：使用する TTS モデル

##### `input`
- タイプ：文字列
- 必須：はい
- 最大長：4096 文字
- 説明：音声に変換するテキスト

##### `voice`
- タイプ：文字列
- 必須：はい
- 選択可能な値：alloy, echo, fable, onyx, nova, shimmer
- 説明：音声を生成する際に使用する声

##### `response_format`
- タイプ：文字列
- 必須：いいえ
- デフォルト値：mp3
- 選択可能な値：mp3, opus, aac, flac, wav, pcm
- 説明：オーディオ出力形式

##### `speed`
- タイプ：数値
- 必須：いいえ
- デフォルト値：1.0
- 範囲：0.25 - 4.0
- 説明：生成される音声の速度

#### 音声認識

##### `file`
- タイプ：ファイル
- 必須：はい
- サポート形式：flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, webm
- 説明：書き起こしを行うオーディオファイル

##### `model`
- タイプ：文字列
- 必須：はい
- 現在サポートされているのは：whisper-1 のみ
- 説明：使用するモデル ID

##### `language`
- タイプ：文字列
- 必須：いいえ
- 形式：ISO-639-1 (例: "en")
- 説明：音声の言語。提供することで精度が向上する場合があります

##### `prompt`
- タイプ：文字列
- 必須：いいえ
- 説明：モデルのスタイルを指示したり、前のオーディオセグメントを継続したりするために使用されるテキスト

##### `response_format`
- タイプ：文字列
- 必須：いいえ
- デフォルト値：json
- 選択可能な値：json, text, srt, verbose_json, vtt
- 説明：出力形式

##### `temperature`
- タイプ：数値
- 必須：いいえ
- デフォルト値：0
- 範囲：0 - 1
- 説明：サンプリング温度。値が高いほど出力はランダムになります

##### `timestamp_granularities`
- タイプ：配列
- 必須：いいえ
- デフォルト値：segment
- 選択可能な値：word, segment
- 説明：書き起こしのタイムスタンプの粒度

#### 音声翻訳

##### `file`
- タイプ：ファイル
- 必須：はい
- サポート形式：flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, webm
- 説明：翻訳を行うオーディオファイル

##### `model`
- タイプ：文字列
- 必須：はい
- 現在サポートされているのは：whisper-1 のみ
- 説明：使用するモデル ID

##### `prompt`
- タイプ：文字列
- 必須：いいえ
- 説明：モデルのスタイルを指示するために使用される英語のテキスト

##### `response_format`
- タイプ：文字列
- 必須：いいえ
- デフォルト値：json
- 選択可能な値：json, text, srt, verbose_json, vtt
- 説明：出力形式

##### `temperature`
- タイプ：数値
- 必須：いいえ
- デフォルト値：0
- 範囲：0 - 1
- 説明：サンプリング温度。値が高いほど出力はランダムになります

## 📥 レスポンス

### 成功レスポンス

#### テキスト読み上げ

バイナリオーディオファイルの内容を返します。

#### 音声認識

##### 基本 JSON 形式

```json
{
  "text": "转录的文本内容"
}
```

##### 詳細 JSON 形式

```json
{
  "task": "transcribe",
  "language": "english",
  "duration": 8.47,
  "text": "完整的转录文本",
  "segments": [
    {
      "id": 0,
      "seek": 0,
      "start": 0.0,
      "end": 3.32,
      "text": "分段的转录文本",
      "tokens": [50364, 440, 7534],
      "temperature": 0.0,
      "avg_logprob": -0.286,
      "compression_ratio": 1.236,
      "no_speech_prob": 0.009
    }
  ]
}
```

#### 音声翻訳

```json
{
  "text": "翻译后的英文文本"
}
```

### エラーレスポンス

リクエストに問題が発生した場合、API は HTTP ステータスコード 4XX〜5XX の範囲でエラーレスポンスオブジェクトを返します。

#### 一般的なエラー ステータスコード

- `400 Bad Request`: リクエストパラメータが無効です
- `401 Unauthorized`: API キーが無効であるか、提供されていません
- `429 Too Many Requests`: API 呼び出し制限を超過しました
- `500 Internal Server Error`: サーバー内部エラー

エラーレスポンス例:

```json
{
  "error": {
    "message": "文件格式不支持",
    "type": "invalid_request_error",
    "param": "file",
    "code": "invalid_file_format"
  }
}
```