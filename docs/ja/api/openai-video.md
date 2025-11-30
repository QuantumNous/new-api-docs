# OpenAI ビデオフォーマット（Soraフォーマット）

OpenAI動画生成インターフェースを呼び出して動画を生成します。Soraなどのモデルをサポートしており、OpenAIビデオフォーマットを使用してKling、Jimeng、Viduを呼び出すこともサポートしています。

## 動画の生成

### API エンドポイント

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
| prompt | string | はい | 生成する動画を記述するテキストプロンプト |
| model | string | いいえ | 動画生成モデル。デフォルトは sora-2 |
| seconds | string | いいえ | 動画の長さ（秒）。デフォルトは 4 秒 |
| size | string | いいえ | 出力解像度。幅x高さの形式。デフォルトは 720x1280 |
| input_reference | file | いいえ | 入力画像ファイル（画像から動画を生成する場合に使用）。入力画像は対応する幅と高さ(size)に準拠する必要があります |
| metadata | string | いいえ | 拡張パラメータ（JSON文字列形式） |

#### metadata パラメータの説明

metadata パラメータの役割は、非Soraモデル固有のパラメータ（例：Alibaba Cloud Wanxiangの画像URL、透かし、プロンプトのスマートな書き換えなど）を渡すことです。metadata パラメータの形式は JSON 文字列です。例：
```json
{
  "img_url": "https://example.com/image.jpg",
  "watermark": false,
  "prompt_extend": true
}
```

### リクエスト例

#### テキストから動画を生成 (プロンプトのみ)

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级" \
  -F "model=sora-2" \
  -F "seconds=5" \
  -F "size=1920x1080"
```

#### 画像から動画を生成 (テキストプロンプト + 画像ファイル)

```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=猫咪慢慢睁开眼睛，伸懒腰" \
  -F "model=sora-2" \
  -F "seconds=3" \
  -F "size=1920x1080" \
  -F "input_reference=@/path/to/cat.jpg"
```

#### Alibaba Cloud Wanxiang 動画生成例

##### テキストから動画を生成 (Wanxiang 2.5)
```bash
curl https://你的newapi服务器地址/v1/videos \
  -H "Authorization: Bearer sk-xxxx" \
  -F "prompt=一只可爱的小猫在花园里玩耍，阳光明媚，色彩鲜艳" \
  -F "model=wan2.5-t2v-preview" \
  -F "seconds=5" \
  -F "size=1920*1080"
```

##### 画像から動画を生成 (Wanxiang 2.5)
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
| id | string | 動画タスクID |
| object | string | オブジェクトタイプ。固定で "video" |
| model | string | 使用されたモデル名 |
| created_at | integer | 作成タイムスタンプ |
| status | string | タスクステータス（processing: 処理中） |
| progress | integer | 生成進捗率（パーセンテージ） |

## 動画の照会

タスクIDに基づいて動画生成タスクのステータスと結果を照会します。

### API エンドポイント

```
GET /v1/videos/{video_id}
```

### パスパラメータ

| パラメータ | タイプ | 必須 | 説明 |
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
| id | string | 動画タスクID |
| object | string | オブジェクトタイプ。固定で "video" |
| model | string | 使用されたモデル名 |
| created_at | integer | 作成タイムスタンプ |
| status | string | タスクステータス（processing: 処理中, succeeded: 成功, failed: 失敗） |
| progress | integer | 生成進捗率（パーセンテージ） |
| expires_at | integer | リソースの有効期限タイムスタンプ |
| size | string | 動画の解像度 |
| seconds | string | 動画の長さ（秒） |
| quality | string | 動画の品質 |
| url | string | 動画ダウンロードリンク（完了時） |

## 動画タスクステータスの取得

タスクIDに基づいて動画生成タスクの詳細情報を取得します。

### API エンドポイント

```
GET /v1/videos/{video_id}
```

### パスパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | 取得する動画タスク識別子 |

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
| id | string | 動画タスクの一意な識別子 |
| object | string | オブジェクトタイプ。固定で "video" |
| model | string | 生成動画のモデル名 |
| status | string | 動画タスクの現在のライフサイクルステータス |
| progress | integer | 生成タスクのおおよその完了パーセンテージ |
| created_at | integer | タスク作成時のUnixタイムスタンプ（秒） |
| expires_at | integer | ダウンロード可能なリソースの有効期限が切れるUnixタイムスタンプ（秒）。設定されている場合 |
| size | string | 生成動画の解像度 |
| seconds | string | 生成動画クリップの長さ（秒） |
| quality | string | 動画の品質 |
| remixed_from_video_id | string | この動画がリミックスされたものである場合、ソース動画の識別子 |
| error | object | 生成に失敗した場合、エラー情報を含むオブジェクト |

## 動画コンテンツの取得

完了した動画コンテンツをダウンロードします。

### API エンドポイント

```
GET /v1/videos/{video_id}/content
```

### パスパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | ダウンロードする動画識別子 |

### クエリパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|------|------|------|------|
| variant | string | いいえ | 返されるダウンロード可能なリソースのタイプ。デフォルトはMP4動画 |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

### レスポンスの説明

動画ファイルストリームを直接返します。Content-Typeは `video/mp4` です。

#### レスポンスヘッダー

| フィールド | 説明 |
|------|------|
| Content-Type | 動画ファイルタイプ。通常 video/mp4 |
| Content-Length | 動画ファイルサイズ（バイト） |
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

### 401 - 未認証
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
- `sora-2`: Sora動画生成モデル

### OpenAIフォーマットを介して呼び出されるその他のサービス
- Alibaba Cloud Wanxiang (Ali Wan): `wan2.5-t2v-preview` (テキストから動画), `wan2.5-i2v-preview` (画像から動画), `wan2.2-i2v-flash`, `wan2.2-i2v-plus`, `wanx2.1-i2v-plus`, `wanx2.1-i2v-turbo` を使用
- Kling AI (Kling): `kling-v1`, `kling-v2-master` を使用
- Jimeng: `jimeng_vgfm_t2v_l20`, `jimeng_vgfm_i2v_l20` を使用
- Vidu: `viduq1` を使用

## Alibaba Cloud Wanxiang 特殊事項

### サポートされている機能
- **テキストから動画を生成 (t2v)**: テキストプロンプトのみを使用して動画を生成
- **画像から動画を生成 (i2v)**: テキストプロンプト+画像を使用して動画を生成
- **首尾フレームから動画を生成 (kf2v)**: 開始フレームと終了フレームの画像を特定して動画を生成
- **音声生成 (s2v)**: 音声と動画の結合をサポート

### 解像度のサポート
- **480P**: 832×480, 480×832, 624×624
- **720P**: 1280×720, 720×1280, 960×960, 1088×832, 832×1088
- **1080P**: 1920×1080, 1080×1920, 1440×1440, 1632×1248, 1248×1632

### 特殊パラメータ
- `watermark`: 透かしを追加するかどうか（デフォルト false）
- `prompt_extend`: プロンプトのスマートな書き換えを有効にするか（デフォルト true）
- `audio`: 音声を追加するかどうか（wan2.5のみサポート）
- `seed`: シード値（乱数シード）

### モデルの特徴
- **wan2.5-i2v-preview**: Wanxiang 2.5 プレビューバージョン。音声付き動画をサポート。推奨
- **wan2.2-i2v-flash**: Wanxiang 2.2 高速版。生成速度が速い。音声なし動画
- **wan2.2-i2v-plus**: Wanxiang 2.2 プロフェッショナル版。画質が高い。音声なし動画
- **wanx2.1-i2v-plus**: Wanxiang 2.1 プロフェッショナル版。安定バージョン
- **wanx2.1-i2v-turbo**: Wanxiang 2.1 高速版

## ベストプラクティス

1. **リクエスト形式**: `multipart/form-data` 形式を使用します。これはOpenAI公式が推奨する方法です
2. **input_referenceパラメータ**: 画像から動画を生成する機能に使用されます。画像ファイルをアップロードする際は `@filename` 構文を使用します
3. **プロンプトの最適化**: スタイルや品質要件を含む、詳細で具体的な記述語を使用します
4. **パラメータ設定**: 要件に応じて、長さと解像度を適切に設定します
5. **Alibaba Cloud Wanxiang 特殊事項**:
   - ファイルの直接アップロードは**サポートされていません**。すべてのリソースはURLを介して渡されます
   - `metadata` パラメータを使用して、すべての拡張パラメータを渡します（JSON文字列形式）
   - 画像から動画を生成する場合、`metadata.img_url` を使用して画像URLを渡します
   - 首尾フレームから動画を生成する場合、`metadata.first_frame_url` と `metadata.last_frame_url` を使用します
6. **エラー処理**: 適切な再試行メカニズムとエラー処理を実装します
7. **非同期処理**: 動画生成は非同期タスクであるため、ステータスをポーリングして照会する必要があります
8. **リソース管理**: 不要になった動画ファイルは速やかにダウンロードし、クリーンアップします

## JavaScript サンプル

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

// 画像から動画を生成する例
async function generateVideoWithImage() {
  const formData = new FormData();
  formData.append('prompt', '猫咪慢慢睁开眼睛，伸懒腰');
  formData.append('model', 'sora-2');
  formData.append('seconds', '3');
  formData.append('size', '1920x1080');
  
  // 画像ファイルを追加
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

### Alibaba Cloud Wanxiang 呼び出し例

```javascript
// Alibaba Cloud Wanxiang テキストから動画を生成
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

// Alibaba Cloud Wanxiang 画像から動画を生成
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

// Alibaba Cloud Wanxiang 首尾フレームから動画を生成
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