# 视频API使用示例和最佳实践

本文档提供了newapi视频生成API的完整使用示例和最佳实践指南。

## 完整使用流程示例

### 1. NewAPI格式完整流程

```javascript
// 1. 生成视频
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

// 2. 轮询查询状态
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
        throw new Error(`视频生成失败: ${result.error?.message || '未知错误'}`);
      }
      
      // 等待后重试
      const delay = attempt < 6 ? 5000 : (attempt < 12 ? 10000 : 30000);
      await new Promise(resolve => setTimeout(resolve, delay));
      
    } catch (error) {
      console.error(`第 ${attempt + 1} 次尝试失败:`, error);
      if (attempt === maxAttempts - 1) {
        throw error;
      }
    }
  }
  
  throw new Error('达到最大轮询次数');
}

// 3. 下载视频
async function downloadVideo(taskId) {
  const response = await fetch(`https://你的newapi服务器地址/v1/videos/${taskId}/content`, {
    headers: {
      'Authorization': 'Bearer sk-xxxx'
    }
  });

  if (!response.ok) {
    throw new Error(`下载失败: ${response.statusText}`);
  }

  const blob = await response.blob();
  return blob;
}

// 完整流程示例
async function completeVideoWorkflow() {
  try {
    // 生成视频
    console.log('正在生成视频...');
    const taskId = await generateVideoWithNewAPI();
    console.log('任务ID:', taskId);

    // 轮询状态
    console.log('正在查询生成状态...');
    const result = await pollVideoStatus(taskId);
    console.log('视频生成完成:', result.url);

    // 下载视频
    console.log('正在下载视频...');
    const videoBlob = await downloadVideo(taskId);
    
    // 保存视频
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

### 2. OpenAI兼容格式完整流程

```javascript
// 1. 生成视频 (OpenAI格式)
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

// 2. 查询状态 (OpenAI格式)
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
      
      // 等待后重试
      const delay = attempt < 6 ? 5000 : (attempt < 12 ? 10000 : 30000);
      await new Promise(resolve => setTimeout(resolve, delay));
      
    } catch (error) {
      console.error(`第 ${attempt + 1} 次尝试失败:`, error);
      if (attempt === maxAttempts - 1) {
        throw error;
      }
    }
  }
  
  throw new Error('达到最大轮询次数');
}
```

## 不同模型的详细示例

### 可灵AI (Kling) 示例

```bash
# 文生视频
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

# 图生视频
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

### 即梦 (Jimeng) 示例

```bash
# 文生视频
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

# 图生视频
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

### Vidu 示例

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

## 错误处理最佳实践

### 1. 完整的错误处理示例

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

// 使用示例
async function exampleUsage() {
  const client = new VideoAPIClient('sk-xxxx', 'https://你的newapi服务器地址');
  
  try {
    // 生成视频
    const result = await client.generateVideo({
      model: 'kling-v1',
      prompt: '一只可爱的小狗在花园里玩耍',
      duration: 5
    });
    
    console.log('任务创建成功:', result.task_id);
    
    // 轮询状态
    const status = await client.pollStatus(result.task_id, 'newapi', {
      maxAttempts: 20,
      initialDelay: 3000
    });
    
    console.log('视频生成完成:', status.url);
    
    // 下载视频
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

## 性能优化建议

### 1. 并发控制

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

### 2. 缓存策略

```javascript
class VideoCache {
  constructor(ttl = 3600000) { // 1小时
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

## 监控和日志

### 1. 性能监控

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

## 最佳实践总结

### 1. API选择
- **NewAPI格式** (`/v1/video/generations`): 适合需要更多自定义参数的场景
- **OpenAI格式** (`/v1/videos`): 适合与OpenAI生态系统集成的场景

### 2. 错误处理
- 实现指数退避重试机制
- 区分临时错误和永久错误
- 提供有意义的错误信息

### 3. 性能优化
- 控制并发请求数量
- 实现适当的缓存策略
- 监控API调用性能

### 4. 用户体验
- 提供进度反馈
- 实现超时处理
- 支持取消操作

### 5. 资源管理
- 及时下载生成的视频
- 清理临时文件
- 监控存储使用情况

这些最佳实践可以帮助您构建稳定、高效的视频生成应用。