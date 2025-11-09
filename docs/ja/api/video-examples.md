# 動画APIの使用例とベストプラクティス

このドキュメントでは、New APIの動画生成APIの完全な使用例とベストプラクティスガイドを提供します。

## 完全な使用フローの例

### 1. New API形式の完全なフロー

```javascript
// 1. 動画の生成
async function generateVideoWithNewAPI() {
  const response = await fetch('https://你的newapi服务器地址/v1/video/generations', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer sk-xxxx',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'kling-v1',
      prompt: '一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级',
      size: '1920x1080',
      duration: 5,
      metadata: {
        seed: 20231234,
        negative_prompt: '模糊, 低质量'
      }
    })
  });

  const result = await response.json();
  return result.task_id;
}

// 2. ポーリングによるステータス照会
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
        throw new Error(`動画生成失敗: ${result.error?.message || '未知错误'}`);
      }
      
      // 待機後にリトライ
      const delay = attempt < 6 ? 5000 : (attempt < 12 ? 10000 : 30000);
      await new Promise(resolve => setTimeout(resolve, delay));
      
    } catch (error) {
      console.error(`第 ${attempt + 1} 次尝试失败:`, error);
      if (attempt === maxAttempts - 1) {
        throw error;
      }
    }
  }
  
  throw new Error('最大ポーリング回数に達しました');
}

// 3. 動画のダウンロード
async function downloadVideo(taskId) {
  const response = await fetch(`https://你的newapi服务器地址/v1/videos/${taskId}/content`, {
    headers: {
      'Authorization': 'Bearer sk-xxxx'
    }
  });

  if (!response.ok) {
    throw new Error(`ダウンロード失敗: ${response.statusText}`);
  }

  const blob = await response.blob();
  return blob;
}

// 完全なフローの例
async function completeVideoWorkflow() {
  try {
    // 動画の生成
    console.log('正在生成视频...');
    const taskId = await generateVideoWithNewAPI();
    console.log('任务ID:', taskId);

    // ステータスのポーリング
    console.log('正在查询生成状态...');
    const result = await pollVideoStatus(taskId);
    console.log('视频生成完成:', result.url);

    // 動画のダウンロード
    console.log('正在下载视频...');
    const videoBlob = await downloadVideo(taskId);
    
    // 動画の保存
    const url = URL.createObjectURL(videoBlob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `video_${taskId}.mp4`;
    a.click();
    URL.revokeObjectURL(url);
    
    console.log('视频下载完成');
  } catch (error) {
    console.error('流程失败:', error);
  }
}
```

### 2. OpenAI互換形式の完全なフロー

```javascript
// 1. 動画の生成 (OpenAI形式)
async function generateVideoWithOpenAIFormat() {
  const response = await fetch('https://你的newapi服务器地址/v1/videos', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer sk-xxxx',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'sora-2',
      prompt: '一个穿着宇航服的宇航员在月球上行走, 高品质, 电影级',
      seconds: '5',
      size: '1920x1080'
    })
  });

  const result = await response.json();
  return result.id;
}

// 2. ステータス照会 (OpenAI形式)
async function pollVideoStatusOpenAI(videoId, maxAttempts = 30) {
  const baseUrl = 'https://你的newapi服务器地址';
  const headers = {
    'Authorization': 'Bearer sk-xxxx',
    'Content-Type': 'application/json'
  };

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      const response = await fetch(`${baseUrl}/v1/videos/${videoId}`, {
        headers
      });
      
      const result = await response.json();
      
      if (result.status === 'succeeded') {
        return result;
      } else if (result.status === 'failed') {
        throw new Error(`视频生成失败: ${result.error?.message || '未知错误'}`);
      }
      
      // 待機後にリトライ
      const delay = attempt < 6 ? 5000 : (attempt < 12 ? 10000 : 30000);
      await new Promise(resolve => setTimeout(resolve, delay));
      
    } catch (error) {
      console.error(`第 ${attempt + 1} 次尝试失败:`, error);
      if (attempt === maxAttempts - 1) {
        throw error;
      }
    }
  }
  
  throw new Error('最大ポーリング回数に達しました');
}
```

## 各種モデルの詳細な使用例

### 可霊AI (Kling) の例

```bash
# テキストから動画を生成
curl -X POST https://你的newapi服务器地址/v1/video/generations \
  -H "Authorization: Bearer sk-xxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kling-v1",
    "prompt": "一只橘猫在阳光下打盹，毛发蓬松，表情安详",
    "duration": 5,
    "metadata": {
      "seed": 12345,
      "negative_prompt": "模糊, 扭曲",
      "cfg_scale": 0.8
    }
  }'

# 画像から動画を生成
curl -X POST https://你的newapi服务器地址/v1/video/generations \
  -H "Authorization: Bearer sk-xxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kling-v2-master",
    "image": "https://example.com/cat.jpg",
    "prompt": "猫咪慢慢睁开眼睛，伸懒腰",
    "duration": 3,
    "metadata": {
      "seed": 54321,
      "negative_prompt": "快速动作",
      "camera_control": {
        "type": "simple",
        "config": {
          "horizontal": 1.0,
          "vertical": 0,
          "zoom": 0.5
        }
      }
    }
  }'
```

### 即夢 (Jimeng) の例

```bash
# テキストから動画を生成
curl -X POST https://你的newapi服务器地址/v1/video/generations \
  -H "Authorization: Bearer sk-xxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "jimeng_vgfm_t2v_l20",
    "prompt": "海浪拍打着礁石，溅起白色的浪花",
    "metadata": {
      "req_key": "jimeng_vgfm_t2v_l20",
      "aspect_ratio": "16:9",
      "duration": 5
    }
  }'

# 画像から動画を生成
curl -X POST https://你的newapi服务器地址/v1/video/generations \
  -H "Authorization: Bearer sk-xxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "jimeng_vgfm_i2v_l20",
    "image": "https://example.com/landscape.jpg",
    "prompt": "云朵缓缓飘过天空",
    "metadata": {
      "req_key": "jimeng_vgfm_i2v_l20",
      "image_urls": ["https://example.com/landscape.jpg"],
      "aspect_ratio": "16:9"
    }
  }'
```

### Vidu の例

```bash
curl -X POST https://你的newapi服务器地址/v1/video/generations \
  -H "Authorization: Bearer sk-xxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "viduq1",
    "prompt": "未来城市的夜景，霓虹灯闪烁",
    "size": "1920x1080",
    "duration": 5,
    "metadata": {
      "resolution": "1080p",
      "movement_amplitude": "medium",
      "bgm": true,
      "seed": 0,
      "callback_url": "https://your-callback-url.com/webhook"
    }
  }'
```

## エラー処理のベストプラクティス

### 1. 完全なエラー処理の例

```javascript
class VideoAPIClient {
  constructor(apiKey, baseUrl) {
    this.apiKey = apiKey;
    this.baseUrl = baseUrl;
  }

  async generateVideo(params, format = 'newapi') {
    try {
      const endpoint = format === 'openai' ? '/v1/videos' : '/v1/video/generations';
      
      const response = await fetch(`${this.baseUrl}${endpoint}`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(params)
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new VideoAPIError(response.status, errorData);
      }

      return await response.json();
    } catch (error) {
      if (error instanceof VideoAPIError) {
        throw error;
      }
      throw new VideoAPIError(0, { message: error.message });
    }
  }

  async pollStatus(taskId, format = 'newapi', options = {}) {
    const {
      maxAttempts = 30,
      initialDelay = 2000,
      maxDelay = 30000
    } = options;

    let delay = initialDelay;
    
    for (let attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        const endpoint = format === 'openai' 
          ? `/v1/videos/${taskId}` 
          : `/v1/video/generations/${taskId}`;
          
        const response = await fetch(`${this.baseUrl}${endpoint}`, {
          headers: {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json'
          }
        });

        if (!response.ok) {
          const errorData = await response.json();
          throw new VideoAPIError(response.status, errorData);
        }

        const result = await response.json();
        
        if (result.status === 'succeeded') {
          return result;
        } else if (result.status === 'failed') {
          throw new VideoAPIError(400, { 
            message: result.error?.message || '视频生成失败' 
          });
        }

        // 等待后重试
        await this.sleep(delay);
        delay = Math.min(delay * 1.5, maxDelay);
        
      } catch (error) {
        if (error instanceof VideoAPIError) {
          throw error;
        }
        console.error(`第 ${attempt + 1} 次轮询失败:`, error);
        
        if (attempt === maxAttempts - 1) {
          throw new VideoAPIError(0, { message: '轮询超时' });
        }
      }
    }
  }

  async downloadVideo(taskId) {
    try {
      const response = await fetch(`${this.baseUrl}/v1/videos/${taskId}/content`, {
        headers: {
          'Authorization': `Bearer ${this.apiKey}`
        }
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new VideoAPIError(response.status, errorData);
      }

      return await response.blob();
    } catch (error) {
      if (error instanceof VideoAPIError) {
        throw error;
      }
      throw new VideoAPIError(0, { message: error.message });
    }
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

class VideoAPIError extends Error {
  constructor(status, data) {
    super(data.message || '未知错误');
    this.status = status;
    this.data = data;
    this.name = 'VideoAPIError';
  }
}

// 使用例
async function exampleUsage() {
  const client = new VideoAPIClient('sk-xxxx', 'https://你的newapi服务器地址');
  
  try {
    // 動画の生成
    const result = await client.generateVideo({
      model: 'kling-v1',
      prompt: '一只可爱的小狗在花园里玩耍',
      duration: 5
    });
    
    console.log('任务创建成功:', result.task_id);
    
    // ステータスのポーリング
    const status = await client.pollStatus(result.task_id, 'newapi', {
      maxAttempts: 20,
      initialDelay: 3000
    });
    
    console.log('视频生成完成:', status.url);
    
    // 動画のダウンロード
    const videoBlob = await client.downloadVideo(result.task_id);
    console.log('视频大小:', videoBlob.size);
    
  } catch (error) {
    if (error instanceof VideoAPIError) {
      console.error(`API错误 (${error.status}):`, error.message);
    } else {
      console.error('未知错误:', error);
    }
  }
}
```

## パフォーマンス最適化の推奨事項

### 1. 並行処理制御

```javascript
class VideoGenerationManager {
  constructor(client, maxConcurrent = 3) {
    this.client = client;
    this.maxConcurrent = maxConcurrent;
    this.running = 0;
    this.queue = [];
  }

  async generateVideo(params) {
    return new Promise((resolve, reject) => {
      this.queue.push({ params, resolve, reject });
      this.processQueue();
    });
  }

  async processQueue() {
    if (this.running >= this.maxConcurrent || this.queue.length === 0) {
      return;
    }

    this.running++;
    const { params, resolve, reject } = this.queue.shift();

    try {
      const result = await this.client.generateVideo(params);
      const status = await this.client.pollStatus(result.task_id);
      resolve(status);
    } catch (error) {
      reject(error);
    } finally {
      this.running--;
      this.processQueue();
    }
  }
}
```

### 2. キャッシュ戦略

```javascript
class VideoCache {
  constructor(ttl = 3600000) { // 1時間
    this.cache = new Map();
    this.ttl = ttl;
  }

  generateKey(params) {
    return JSON.stringify(params);
  }

  get(params) {
    const key = this.generateKey(params);
    const cached = this.cache.get(key);
    
    if (cached && Date.now() - cached.timestamp < this.ttl) {
      return cached.result;
    }
    
    this.cache.delete(key);
    return null;
  }

  set(params, result) {
    const key = this.generateKey(params);
    this.cache.set(key, {
      result,
      timestamp: Date.now()
    });
  }

  clear() {
    this.cache.clear();
  }
}
```

## モニタリングとログ

### 1. パフォーマンスモニタリング

```javascript
class VideoAPIMonitor {
  constructor() {
    this.metrics = {
      totalRequests: 0,
      successfulRequests: 0,
      failedRequests: 0,
      averageResponseTime: 0,
      errorTypes: new Map()
    };
  }

  async measureTime(fn) {
    const start = Date.now();
    try {
      const result = await fn();
      this.recordSuccess(Date.now() - start);
      return result;
    } catch (error) {
      this.recordFailure(Date.now() - start, error);
      throw error;
    }
  }

  recordSuccess(responseTime) {
    this.metrics.totalRequests++;
    this.metrics.successfulRequests++;
    this.updateAverageResponseTime(responseTime);
  }

  recordFailure(responseTime, error) {
    this.metrics.totalRequests++;
    this.metrics.failedRequests++;
    this.updateAverageResponseTime(responseTime);
    
    const errorType = error.constructor.name;
    this.metrics.errorTypes.set(
      errorType, 
      (this.metrics.errorTypes.get(errorType) || 0) + 1
    );
  }

  updateAverageResponseTime(responseTime) {
    const total = this.metrics.totalRequests;
    this.metrics.averageResponseTime = 
      (this.metrics.averageResponseTime * (total - 1) + responseTime) / total;
  }

  getMetrics() {
    return {
      ...this.metrics,
      successRate: this.metrics.totalRequests > 0 
        ? this.metrics.successfulRequests / this.metrics.totalRequests 
        : 0
    };
  }
}
```

## ベストプラクティスのまとめ

### 1. APIの選択
- **New API形式** (`/v1/video/generations`): より多くのカスタムパラメータが必要なシナリオに適しています
- **OpenAI形式** (`/v1/videos`): OpenAIエコシステムとの統合に適したシナリオに適しています

### 2. エラー処理
- 指数バックオフによるリトライメカニズムを実装する
- 一時的なエラーと永続的なエラーを区別する
- 意味のあるエラーメッセージを提供する

### 3. パフォーマンス最適化
- 並行リクエスト数を制御する
- 適切なキャッシュ戦略を実装する
- API呼び出しのパフォーマンスを監視する

### 4. ユーザーエクスペリエンス
- 進捗フィードバックを提供する
- タイムアウト処理を実装する
- キャンセル操作をサポートする

### 5. リソース管理
- 生成された動画を速やかにダウンロードする
- 一時ファイルをクリーンアップする
- ストレージの使用状況を監視する

これらのベストプラクティスは、安定した効率的な動画生成アプリケーションの構築に役立ちます。