# ビデオ API の照会

タスクIDに基づいて、ビデオ生成タスクのステータスと結果を照会します。

## ビデオステータスの照会

### APIエンドポイント

```
GET /v1/video/generations/{task_id}
```

### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| task_id | string | はい | タスクID |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/video/generations/{task_id}' \
  -H "Authorization: Bearer sk-xxxx"
```

### レスポンス形式

#### 200 - 成功レスポンス

```json
{
  "error": null,
  "format": "mp4",
  "metadata": {
    "duration": 5,
    "fps": 30,
    "height": 512,
    "seed": 20231234,
    "width": 512
  },
  "status": "succeeded",
  "task_id": "abcd1234efgh",
  "url": "https://example.com/video.mp4"
}
```

#### レスポンスフィールドの説明

| フィールド | 型 | 説明 |
|------|------|------|
| task_id | string | タスクID |
| status | string | タスクステータス（processing: 処理中, succeeded: 成功, failed: 失敗） |
| format | string | ビデオ形式 |
| url | string | ビデオリソースURL（成功時） |
| metadata | object | 結果メタデータ |
| error | object | エラー情報（成功時はnull） |

### ステータスの説明

| ステータス | 説明 |
|------|------|
| processing | タスクは処理中です |
| queued | タスクは処理待ちでキューに入っています |
| in_progress | タスクは進行中です |
| succeeded | タスクは正常に完了しました |
| failed | タスクは失敗しました |

## OpenAI互換形式での照会

### APIエンドポイント

```
GET /v1/videos/{video_id}
```

### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | ビデオタスクID |

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
  "url": "https://example.com/video.mp4"
}
```

#### レスポンスフィールドの説明

| フィールド | 型 | 説明 |
|------|------|------|
| id | string | ビデオタスクの一意の識別子 |
| object | string | オブジェクトタイプ。「video」で固定 |
| model | string | ビデオを生成したモデル名 |
| status | string | ビデオタスクの現在のライフサイクルステータス |
| progress | integer | 生成タスクのおおよその完了パーセンテージ |
| created_at | integer | タスク作成時のUnixタイムスタンプ（秒） |
| expires_at | integer | ダウンロード可能なリソースが期限切れになるUnixタイムスタンプ（秒）。設定されている場合 |
| size | string | 生成されたビデオの解像度 |
| seconds | string | 生成されたビデオクリップの長さ（秒） |
| quality | string | ビデオ品質 |
| url | string | ビデオダウンロードリンク（完了時） |

## ビデオコンテンツの取得

### APIエンドポイント

```
GET /v1/videos/{video_id}/content
```

### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| video_id | string | はい | ダウンロードするビデオの識別子 |

### クエリパラメータ

| パラメータ | 型 | 必須 | 説明 |
|------|------|------|------|
| variant | string | いいえ | 返されるダウンロード可能なリソースのタイプ。デフォルトはMP4ビデオ |

### リクエスト例

```bash
curl 'https://你的newapi服务器地址/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

### レスポンスの説明

ビデオファイルストリームが直接返されます。Content-Typeは `video/mp4` です。

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
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 401 - 未承認 (Unauthorized)

```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 403 - 権限なし (Forbidden)

```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

### 404 - タスクが存在しません (Task Not Found)

```json
{
  "code": null,
  "message": "Task not found",
  "param": "task_id",
  "type": "invalid_request_error"
}
```

### 500 - サーバー内部エラー (Internal Server Error)

```json
{
  "code": null,
  "message": "string",
  "param": "string",
  "type": "string"
}
```

## ポーリング戦略

### 推奨されるポーリング間隔

1. **初期ポーリング**: タスク送信後、2〜3秒待機してからポーリングを開始します
2. **ポーリング頻度**: 
   - 最初の30秒間: 5秒ごとに1回ポーリング
   - 30秒〜2分間: 10秒ごとに1回ポーリング
   - 2分経過後: 30秒ごとに1回ポーリング
3. **タイムアウト処理**: 合計タイムアウト時間を5〜10分に設定することを推奨します

### ポーリングのサンプルコード

```javascript
async function pollVideoStatus(taskId, maxAttempts = 30) {
  const baseUrl = 'https://你的newapi服务器地址';
  const headers = {
    'Authorization': 'Bearer sk-xxxx',
    'Content-Type': 'application/json'
  };

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      const response = await fetch(`${baseUrl}/v1/video/generations/${taskId}`, {
        headers
      });
      
      const result = await response.json();
      
      if (result.status === 'succeeded') {
        return result;
      } else if (result.status === 'failed') {
        throw new Error(`Video generation failed: ${result.error?.message || 'Unknown error'}`);
      }
      
      // 等待后重试
      const delay = attempt < 6 ? 5000 : (attempt < 12 ? 10000 : 30000);
      await new Promise(resolve => setTimeout(resolve, delay));
      
    } catch (error) {
      console.error(`Attempt ${attempt + 1} failed:`, error);
      if (attempt === maxAttempts - 1) {
        throw error;
      }
    }
  }
  
  throw new Error('Max polling attempts reached');
}
```

## ベストプラクティス

1. **ステータスチェック**: 定期的にタスクステータスをチェックし、過度に頻繁なリクエストを避けます
2. **エラー処理**: ネットワークエラーやAPIエラーを含む、あらゆる種類のエラー状況を適切に処理します
3. **タイムアウト設定**: 無限の待機を避けるため、合理的なタイムアウト時間を設定します
4. **キャッシュ戦略**: 完了したビデオについては、結果のキャッシュを検討できます
5. **並行処理制御**: 同時に多数の照会リクエストを発行することを避けます
6. **リソースのクリーンアップ**: 不要になったビデオファイルを速やかにダウンロードし、クリーンアップします