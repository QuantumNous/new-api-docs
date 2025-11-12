# OpenAI ビデオフォーマット（Soraフォーマット）

OpenAIビデオ生成インターフェースを呼び出してビデオを生成します。Soraなどのモデルをサポートし、OpenAIビデオフォーマットを使用してKling（可霊）、Jimeng（即夢）、Viduを呼び出すこともサポートしています。

## ビデオ生成

### APIエンドポイント

```
POST /v1/videos
```

### リクエストヘッダー

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| Authorization | string | はい | ユーザー認証トークン (Bearer: sk-xxxx) |

### リクエストパラメータ (multipart/form-data)

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| prompt | string | はい | 生成したいビデオを記述するテキストプロンプト |
| model | string | いいえ | ビデオ生成モデル。デフォルトは sora-2 |
| seconds | string | いいえ | ビデオの長さ（秒）。デフォルトは 4 秒 |
| size | string | いいえ | 出力解像度。幅x高さの形式。デフォルトは 720x1280 |
| input_reference | file | いいえ | 入力画像ファイル（画像からビデオ生成時に使用） |
| metadata | string | いいえ | 拡張パラメータ（JSON文字列形式） |

#### metadata パラメータの説明

metadata パラメータの役割は、Soraモデル固有ではないパラメータ（例：阿里云万相の画像URL、透かし、プロンプトのスマートリライトなど）を渡すことです。metadata パラメータの形式は JSON 文字列です。例：
```json
{
  "img_url": "https://example.com/image.jpg",
  "watermark": false,
  "prompt_extend": true
}
```

### リクエスト例

#### テキストからビデオ生成 (T2V) (テキストプロンプトのみ)

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级" \
  -F "model=sora-2" \
  -F "seconds=5" \
  -F "size=1920x1080"
```

#### 画像からビデオ生成 (I2V) (テキストプロンプト + 画像ファイル)

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=猫咪慢慢睁开眼睛，伸懒腰" \
  -F "model=sora-2" \
  -F "seconds=3" \
  -F "size=1920x1080" \
  -F "input_reference=@/path/to/cat.jpg"
```

#### 阿里云万相 ビデオ生成例

##### テキストからビデオ生成 (Wanxiang 2.5)
```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=一只可爱的小猫在花园里玩耍，阳光明媚，色彩鲜艳" \
  -F "model=wan2.5-t2v-preview" \
  -F "seconds=5" \
  -F "size=1920*1080"
```

##### 画像からビデオ生成 (Wanxiang 2.5)
```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=让这张图片动起来，添加自然的运动效果" \
  -F "model=wan2.5-i2v-preview" \
  -F "seconds=5" \
  -F "size=1280P" \
  -F 'metadata={"img_url":"https://example.com/image.jpg"}'
```

### レスポンス形式

#### 201 - 作成成功

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

#### レスポンスフィールドの説明

| フィールド | タイプ | 説明 |
|------|------|------|
| id | string | ビデオタスクID |
| object | string | オブジェクトタイプ。固定で "video" |
| model | string | 使用されたモデル名 |
| created_at | integer | 作成タイムスタンプ |
| status | string | タスクステータス（processing: 処理中） |
| progress | integer | 生成進捗率（パーセンテージ） |

## ビデオの照会

タスクIDに基づいてビデオ生成タスクのステータスと結果を照会します。

### APIエンドポイント

```
GET /v1/videos/{video_id}
```

### パスパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | ビデオタスクID |

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
  "created_at": 1640995200,
  "status": "succeeded",
  "progress": 100,
  "expires_at": 1641081600,
  "size": "1920x1080",
  "seconds": "5",
  "quality": "standard"
}
```

#### レスポンスフィールドの説明

| フィールド | タイプ | 説明 |
|------|------|------|
| id | string | ビデオタスクID |
| object | string | オブジェクトタイプ。固定で "video" |
| model | string | 使用されたモデル名 |
| created_at | integer | 作成タイムスタンプ |
| status | string | タスクステータス（processing: 処理中, succeeded: 成功, failed: 失敗） |
| progress | integer | 生成進捗率（パーセンテージ） |
| expires_at | integer | リソース有効期限のタイムスタンプ |
| size | string | ビデオ解像度 |
| seconds | string | ビデオの長さ（秒） |
| quality | string | ビデオ品質 |
| url | string | ビデオダウンロードリンク（完了時） |

## ビデオタスクステータスの取得

タスクIDに基づいてビデオ生成タスクの詳細情報を取得します。

### APIエンドポイント

```
GET /v1/videos/{video_id}
```

### パスパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | 取得するビデオタスク識別子 |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

### レスポンス形式

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

#### レスポンスフィールドの説明

| フィールド | タイプ | 説明 |
|------|------|------|
| id | string | ビデオタスクの一意の識別子 |
| object | string | オブジェクトタイプ。固定で "video" |
| model | string | ビデオを生成したモデル名 |
| status | string | ビデオタスクの現在のライフサイクルステータス |
| progress | integer | 生成タスクのおおよその完了パーセンテージ |
| created_at | integer | タスク作成時のUnixタイムスタンプ（秒） |
| expires_at | integer | ダウンロード可能なリソースの有効期限が切れるUnixタイムスタンプ（秒）。設定されている場合 |
| size | string | 生成されたビデオの解像度 |
| seconds | string | 生成されたビデオクリップの長さ（秒） |
| quality | string | ビデオ品質 |
| remixed_from_video_id | string | このビデオがリミックスである場合、ソースビデオの識別子 |
| error | object | 生成に失敗した場合、エラー情報を含むオブジェクト |

## ビデオコンテンツの取得

完了したビデオコンテンツをダウンロードします。

### APIエンドポイント

```
GET /v1/videos/{video_id}/content
```

### パスパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | ダウンロードするビデオの識別子 |

### クエリパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| variant | string | いいえ | 返されるダウンロード可能なリソースのタイプ。デフォルトはMP4ビデオ |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

### レスポンスの説明

ビデオファイルストリームを直接返却します。Content-Typeは `video/mp4` です。

#### レスポンスヘッダー

| フィールド | 説明 |
|------|------|
| Content-Type | ビデオファイルタイプ。通常は video/mp4 |
| Content-Length | ビデオファイルサイズ（バイト） |
| Content-Disposition | ファイルダウンロード情報 |

## エラーレスポンス

### 400 - リクエストパラメータエラー
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 401 - 未承認
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 403 - 権限なし
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 404 - タスクが存在しません
```json
{
  "error": {
    "message": "string",
    "type": "invalid_request_error"
  }
}
```

### 500 - サーバー内部エラー
```json
{
  "error": {
    "message": "string",
    "type": "server_error"
  }
}
```

## サポートされているモデル

### OpenAI互換
- `sora-2`: Soraビデオ生成モデル

### OpenAIフォーマット経由で呼び出されるその他のサービス
- 阿里云万相 (Ali Wan): `wan2.5-t2v-preview` (テキストからビデオ生成), `wan2.5-i2v-preview` (画像からビデオ生成), `wan2.2-i2v-flash`, `wan2.2-i2v-plus`, `wanx2.1-i2v-plus`, `wanx2.1-i2v-turbo` を使用
- 可霊AI (Kling): `kling-v1`, `kling-v2-master` を使用
- 即夢 (Jimeng): `jimeng_vgfm_t2v_l20`, `jimeng_vgfm_i2v_l20` を使用
- Vidu: `viduq1` を使用

## 阿里云万相の特記事項

### サポートされている機能
- **テキストからビデオ生成 (t2v)**: テキストプロンプトのみを使用してビデオを生成
- **画像からビデオ生成 (i2v)**: テキストプロンプト + 画像を使用してビデオを生成
- **最初と最後のフレームからのビデオ生成 (kf2v)**: 最初と最後のフレーム画像を指定してビデオを生成
- **音声生成 (s2v)**: 音声とビデオの結合をサポート

### 解像度のサポート
- **480P**: 832×480, 480×832, 624×624
- **720P**: 1280×720, 720×1280, 960×960, 1088×832, 832×1088
- **1080P**: 1920×1080, 1080×1920, 1440×1440, 1632×1248, 1248×1632

### 特殊パラメータ
- `watermark`: 透かしを追加するかどうか（デフォルトはfalse）
- `prompt_extend`: プロンプトのスマートリライトを有効にするかどうか（デフォルトはtrue）
- `audio`: 音声を追加するかどうか（wan2.5のみサポート）
- `seed`: 乱数シード

### モデルの特徴
- **wan2.5-i2v-preview**: Wanxiang 2.5 プレビューバージョン。音声付きビデオをサポート。推奨
- **wan2.2-i2v-flash**: Wanxiang 2.2 高速版。生成速度が速い。音声なしビデオ
- **wan2.2-i2v-plus**: Wanxiang 2.2 プロフェッショナル版。画質が高い。音声なしビデオ
- **wanx2.1-i2v-plus**: Wanxiang 2.1 プロフェッショナル版。安定バージョン
- **wanx2.1-i2v-turbo**: Wanxiang 2.1 高速版

## ベストプラクティス

1. **リクエスト形式**: `multipart/form-data` 形式を使用します。これはOpenAI公式が推奨する方法です。
2. **input_referenceパラメータ**: 画像からビデオ生成機能に使用されます。画像ファイルをアップロードする際は `@filename` 構文を使用します。
3. **プロンプトの最適化**: スタイルや品質要件を含む、詳細で具体的な記述を使用します。
4. **パラメータ設定**: 要件に応じて、長さと解像度を適切に設定します。
5. **阿里云万相の特記事項**:
   - **ファイルの直接アップロードはサポートされていません**。すべてのリソースはURL経由で渡されます。
   - すべての拡張パラメータは `metadata` パラメータ（JSON文字列形式）を使用して渡します。
   - 画像からビデオ生成では `metadata.img_url` を使用して画像URLを渡します。
   - 最初と最後のフレームからのビデオ生成では `metadata.first_frame_url` と `metadata.last_frame_url` を使用します。
6. **エラー処理**: 適切なリトライメカニズムとエラー処理を実装します。
7. **非同期処理**: ビデオ生成は非同期タスクであるため、ステータスをポーリングして照会する必要があります。
8. **リソース管理**: 不要になったビデオファイルは速やかにダウンロードし、クリーンアップします。

## JavaScriptの例

### FormDataの使用 (推奨)

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

### 阿里云万相呼び出し例

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