# OpenAI ビデオフォーマット

OpenAI動画生成インターフェースを呼び出して動画を生成します。Soraなどのモデルをサポートし、OpenAIビデオフォーマットを使用して可灵、即梦、viduを呼び出すこともサポートしています。

## 動画の生成

### APIエンドポイント

```
POST /v1/videos
```

### リクエストヘッダー

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| Authorization | string | はい | ユーザー認証トークン (Bearer: sk-xxxx) |
| Content-Type | string | はい | multipart/form-data |

### リクエストパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| prompt | string | はい | 生成する動画を説明するテキストプロンプト |
| model | string | いいえ | 動画生成モデル。デフォルトは sora-2 |
| seconds | string | いいえ | 動画の長さ（秒）。デフォルトは 4 秒 |
| size | string | いいえ | 出力解像度。幅x高さの形式。デフォルトは 720x1280 |
| input_reference | file | いいえ | オプションの画像参照。生成のガイドとして使用 |

### リクエスト例

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=sora-2" \
  -F "prompt=A calico cat playing a piano on stage"
```

### レスポンス形式

#### 200 - 成功レスポンス

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "status": "queued",
  "progress": 0,
  "created_at": 1712697600,
  "size": "1024x1808",
  "seconds": "8",
  "quality": "standard"
}
```

#### レスポンスフィールドの説明

| フィールド | 型 | 説明 |
|------|------|------|
| id | string | 動画タスクID |
| object | string | オブジェクトタイプ。固定値は "video" |
| model | string | 使用されたモデル名 |
| status | string | タスクステータス（queued: キュー待ち, processing: 処理中, completed: 完了, failed: 失敗） |
| progress | integer | 処理進捗（0-100） |
| created_at | integer | 作成タイムスタンプ |
| size | string | ビデオ解像度 |
| seconds | string | ビデオの長さ（秒） |
| quality | string | ビデオ品質 |

## 動画の照会

タスクIDに基づいて動画生成タスクのステータスと結果を照会します。

### APIエンドポイント

```
GET /v1/videos/{video_id}
```

### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | 動画タスクID |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

### レスポンス形式

#### 200 - 成功レスポンス

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "status": "completed",
  "progress": 100,
  "created_at": 1712697600,
  "size": "1024x1808",
  "seconds": "8",
  "quality": "standard",
  "url": "https://example.com/video.mp4"
}
```

#### レスポンスフィールドの説明

| フィールド | 型 | 説明 |
|------|------|------|
| id | string | 動画タスクID |
| object | string | オブジェクトタイプ。固定値は "video" |
| model | string | 使用されたモデル名 |
| status | string | タスクステータス（queued: キュー待ち, processing: 処理中, completed: 完了, failed: 失敗） |
| progress | integer | 処理進捗（0-100） |
| created_at | integer | 作成タイムスタンプ |
| size | string | ビデオ解像度 |
| seconds | string | ビデオの長さ（秒） |
| quality | string | ビデオ品質 |
| url | string | ビデオダウンロードリンク（完了時） |

## 動画タスクステータスの取得

タスクIDに基づいて動画生成タスクの詳細情報を取得します。

### APIエンドポイント

```
GET /v1/videos/{video_id}
```

### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | 取得する動画タスク識別子 |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

### レスポンス形式

#### 200 - 成功レスポンス

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "status": "completed",
  "progress": 100,
  "created_at": 1712697600,
  "completed_at": 1712698000,
  "expires_at": 1712784400,
  "size": "1024x1808",
  "seconds": "8",
  "quality": "standard",
  "remixed_from_video_id": null,
  "error": null
}
```

#### レスポンスフィールドの説明

| フィールド | 型 | 説明 |
|------|------|------|
| id | string | 動画タスクの一意の識別子 |
| object | string | オブジェクトタイプ。固定値は "video" |
| model | string | 動画を生成したモデル名 |
| status | string | 動画タスクの現在のライフサイクルステータス |
| progress | integer | 生成タスクのおおよその完了パーセンテージ |
| created_at | integer | タスク作成時のUnixタイムスタンプ（秒） |
| completed_at | integer | タスク完了時のUnixタイムスタンプ（秒）。完了している場合 |
| expires_at | integer | ダウンロード可能なリソースの有効期限が切れるUnixタイムスタンプ（秒）。設定されている場合 |
| size | string | 生成された動画の解像度 |
| seconds | string | 生成された動画クリップの長さ（秒） |
| quality | string | ビデオ品質 |
| remixed_from_video_id | string | この動画がリミックスである場合、ソース動画の識別子 |
| error | object | 生成が失敗した場合、エラー情報を含むオブジェクト |

## 動画コンテンツの取得

完了した動画コンテンツをダウンロードします。

### APIエンドポイント

```
GET /v1/videos/{video_id}/content
```

### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | ダウンロードする動画の識別子 |

### クエリパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| variant | string | いいえ | 返されるダウンロード可能なリソースのタイプ。デフォルトはMP4動画 |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

### レスポンス形式

#### 200 - 成功レスポンス

動画ファイルストリームを直接返します。Content-Typeは `video/mp4` です。

#### レスポンスヘッダーの説明

| フィールド | 型 | 説明 |
|------|------|------|
| Content-Type | string | 動画ファイルタイプ。通常は video/mp4 |
| Content-Length | string | 動画ファイルサイズ（バイト） |
| Content-Disposition | string | ファイルダウンロード情報 |

## エラーレスポンス

### 400 - リクエストパラメータエラー
```json
{
  "error": {
    "message": "Invalid request parameters",
    "type": "invalid_request_error",
    "code": "invalid_parameter"
  }
}
```

### 401 - 未認証
```json
{
  "error": {
    "message": "Invalid API key",
    "type": "authentication_error",
    "code": "invalid_api_key"
  }
}
```

### 403 - 権限なし
```json
{
  "error": {
    "message": "Insufficient permissions",
    "type": "permission_error",
    "code": "insufficient_permissions"
  }
}
```

### 429 - リクエスト頻度制限
```json
{
  "error": {
    "message": "Rate limit exceeded",
    "type": "rate_limit_error",
    "code": "rate_limit_exceeded"
  }
}
```

### 500 - サーバー内部エラー
```json
{
  "error": {
    "message": "Internal server error",
    "type": "server_error",
    "code": "internal_error"
  }
}
```