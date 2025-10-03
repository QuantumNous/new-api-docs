## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 比率 | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス資格情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格比率に影響します | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス割り当て量 | Available service quota for users |

# OpenAI オーディオフォーマット

!!! info "公式ドキュメント"
    [OpenAI Audio](https://platform.openai.com/docs/api-reference/audio)

## 📝 概要

OpenAI オーディオ API は、主に3つの機能を提供します:

1. テキスト読み上げ (TTS) - テキストを自然な音声に変換します
2. 音声認識 (STT) - 音声をテキストに書き起こします
3. オーディオ翻訳 - 英語以外の音声を英語テキストに翻訳します

## 💡 リクエスト例

### テキスト読み上げ (TTS) ✅

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

### 音声認識 (STT) ✅

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

### オーディオ翻訳 ✅

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

#### オーディオ翻訳
```
POST /v1/audio/translations
```

音声を英語テキストに翻訳します。

### 認証方法

APIキー認証のために、リクエストヘッダーに以下を含めます：

```
Authorization: Bearer $NEWAPI_API_KEY
```

ここで `$NEWAPI_API_KEY` はお客様の API キーです。

### リクエストボディパラメータ

#### テキスト読み上げ

##### `model`
- 型：文字列
- 必須：はい
- 選択可能な値：tts-1, tts-1-hd
- 説明：使用する TTS モデル

##### `input`
- 型：文字列  
- 必須：はい
- 最大長：4096 文字
- 説明：音声に変換するテキスト

##### `voice`
- 型：文字列
- 必須：はい
- 選択可能な値：alloy, echo, fable, onyx, nova, shimmer
- 説明：音声を生成する際に使用する声

##### `response_format`
- 型：文字列
- 必須：いいえ
- デフォルト値：mp3
- 選択可能な値：mp3, opus, aac, flac, wav, pcm
- 説明：オーディオ出力フォーマット

##### `speed`
- 型：数値
- 必須：いいえ
- デフォルト値：1.0
- 範囲：0.25 - 4.0
- 説明：生成される音声の速度

#### 音声認識

##### `file`
- 型：ファイル
- 必須：はい
- サポート形式：flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, webm
- 説明：書き起こすオーディオファイル

##### `model`
- 型：文字列
- 必須：はい
- 現在サポートされているのは：whisper-1 のみ
- 説明：使用するモデル ID

##### `language`
- 型：文字列
- 必須：いいえ
- 形式：ISO-639-1 (例: "en")
- 説明：オーディオの言語。提供することで精度が向上します

##### `prompt`
- 型：文字列
- 必須：いいえ
- 説明：モデルのスタイルを指示したり、前のオーディオセグメントを継続したりするために使用されるテキスト

##### `response_format`
- 型：文字列
- 必須：いいえ
- デフォルト値：json
- 選択可能な値：json, text, srt, verbose_json, vtt
- 説明：出力フォーマット

##### `temperature`
- 型：数値
- 必須：いいえ
- デフォルト値：0
- 範囲：0 - 1
- 説明：サンプリング温度。値が高いほど出力がランダムになります

##### `timestamp_granularities`
- 型：配列
- 必須：いいえ
- デフォルト値：segment
- 選択可能な値：word, segment
- 説明：書き起こしのタイムスタンプの粒度

#### オーディオ翻訳

##### `file`
- 型：ファイル
- 必須：はい
- サポート形式：flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, webm
- 説明：翻訳するオーディオファイル

##### `model`
- 型：文字列
- 必須：はい
- 現在サポートされているのは：whisper-1 のみ
- 説明：使用するモデル ID

##### `prompt`
- 型：文字列
- 必須：いいえ
- 説明：モデルのスタイルを指示するために使用される英語のテキスト

##### `response_format`
- 型：文字列
- 必須：いいえ
- デフォルト値：json
- 選択可能な値：json, text, srt, verbose_json, vtt
- 説明：出力フォーマット

##### `temperature`
- 型：数値
- 必須：いいえ
- デフォルト値：0
- 範囲：0 - 1
- 説明：サンプリング温度。値が高いほど出力がランダムになります

## 📥 レスポンス

### 成功レスポンス

#### テキスト読み上げ

バイナリオーディオファイルの内容を返します。

#### 音声認識

##### 基本 JSON フォーマット

```json
{
  "text": "転录的文本内容"
}
```

##### 詳細 JSON フォーマット

```json
{
  "task": "transcribe",
  "language": "english",
  "duration": 8.47,
  "text": "完全な書き起こしテキスト",
  "segments": [
    {
      "id": 0,
      "seek": 0,
      "start": 0.0,
      "end": 3.32,
      "text": "セグメント化された書き起こしテキスト",
      "tokens": [50364, 440, 7534],
      "temperature": 0.0,
      "avg_logprob": -0.286,
      "compression_ratio": 1.236,
      "no_speech_prob": 0.009
    }
  ]
}
```

#### オーディオ翻訳

```json
{
  "text": "翻訳された英語テキスト"
}
```

### エラーレスポンス

リクエストに問題が発生した場合、API は HTTP ステータスコード 4XX〜5XX の範囲でエラーレスポンスオブジェクトを返します。

#### 一般的なエラー ステータスコード

- `400 Bad Request`: リクエストパラメータが無効です
- `401 Unauthorized`: APIキーが無効であるか、提供されていません
- `429 Too Many Requests`: API呼び出し制限を超過しました
- `500 Internal Server Error`: サーバー内部エラー

エラーレスポンス例:

```json
{
  "error": {
    "message": "ファイル形式がサポートされていません",
    "type": "invalid_request_error",
    "param": "file",
    "code": "invalid_file_format"
  }
}
```