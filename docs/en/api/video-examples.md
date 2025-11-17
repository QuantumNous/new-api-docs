# Video API Usage Examples and Best Practices

This document provides complete usage examples and a best practices guide for the New API video generation API.

## Complete Usage Workflow Example

### 1. NewAPI Format Complete Workflow

```javascript
// 1. Generate Video
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

// 2. Poll Status
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
      
      // Wait and retry
      const delay = attempt < 6 ? 5000 : (attempt < 12 ? 10000 : 30000);
      await new Promise(resolve => setTimeout(resolve, delay));
      
    } catch (error) {
      console.error(`Attempt ${attempt + 1} failed:`, error);
      if (attempt === maxAttempts - 1) {
        throw error;
      }
    }
  }
  
  throw new Error('Maximum polling attempts reached');
}

// 3. Download Video
async function downloadVideo(taskId) {
  const response = await fetch(`https://你的newapi服务器地址/v1/videos/${taskId}/content`, {
    headers: {
      'Authorization': 'Bearer sk-xxxx'
    }
  });

  if (!response.ok) {
    throw new Error(`Download failed: ${response.statusText}`);
  }

  const blob = await response.blob();
  return blob;
}

// Complete workflow example
async function completeVideoWorkflow() {
  try {
    // Generating video...
    console.log('正在生成视频...');
    const taskId = await generateVideoWithNewAPI();
    console.log('Task ID:', taskId);

    // Querying generation status...
    console.log('正在查询生成状态...');
    const result = await pollVideoStatus(taskId);
    console.log('Video generation complete:', result.url);

    // Downloading video...
    console.log('正在下载视频...');
    const videoBlob = await downloadVideo(taskId);
    
    // Save video
    const url = URL.createObjectURL(videoBlob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `video_${taskId}.mp4`;
    a.click();
    URL.revokeObjectURL(url);
    
    console.log('Video download complete');
  } catch (error) {
    console.error('Workflow failed:', error);
  }
}
```

### 2. OpenAI Compatible Format Complete Workflow

```javascript
// 1. Generate Video (OpenAI Format)
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

// 2. Poll Status (OpenAI Format)
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
        throw new Error(`Video generation failed: ${result.error?.message || 'Unknown error'}`);
      }
      
      // Wait and retry
      const delay = attempt < 6 ? 5000 : (attempt < 12 ? 10000 : 30000);
      await new Promise(resolve => setTimeout(resolve, delay));
      
    } catch (error) {
      console.error(`Attempt ${attempt + 1} failed:`, error);
      if (attempt === maxAttempts - 1) {
        throw error;
      }
    }
  }
  
  throw new Error('Maximum polling attempts reached');
}
```

## Detailed Examples for Different Models

### Kling AI Example

```bash
# Text-to-Video
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

# Image-to-Video
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

### Jimeng Example

```bash
# Text-to-Video
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

# Image-to-Video
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

### Vidu Example

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

## Error Handling Best Practices

### 1. Complete Error Handling Example

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
            message: result.error?.message || 'Video generation failed' 
          });
        }

        // Wait and retry
        await this.sleep(delay);
        delay = Math.min(delay * 1.5, maxDelay);
        
      } catch (error) {
        if (error instanceof VideoAPIError) {
          throw error;
        }
        console.error(`Attempt ${attempt + 1} polling failed:`, error);
        
        if (attempt === maxAttempts - 1) {
          throw new VideoAPIError(0, { message: 'Polling timeout' });
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
    super(data.message || 'Unknown error');
    this.status = status;
    this.data = data;
    this.name = 'VideoAPIError';
  }
}

// Usage example
async function exampleUsage() {
  const client = new VideoAPIClient('sk-xxxx', 'https://你的newapi服务器地址');
  
  try {
    // Generate video
    const result = await client.generateVideo({
      model: 'kling-v1',
      prompt: '一只可爱的小狗在花园里玩耍',
      duration: 5
    });
    
    console.log('Task creation successful:', result.task_id);
    
    // Poll status
    const status = await client.pollStatus(result.task_id, 'newapi', {
      maxAttempts: 20,
      initialDelay: 3000
    });
    
    console.log('Video generation complete:', status.url);
    
    // Download video
    const videoBlob = await client.downloadVideo(result.task_id);
    console.log('Video size:', videoBlob.size);
    
  } catch (error) {
    if (error instanceof VideoAPIError) {
      console.error(`API Error (${error.status}):`, error.message);
    } else {
      console.error('Unknown error:', error);
    }
  }
}
```

## Performance Optimization Suggestions

### 1. Concurrency Control

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

### 2. Caching Strategy

```javascript
class VideoCache {
  constructor(ttl = 3600000) { // 1 hour
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

## Monitoring and Logging

### 1. Performance Monitoring

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

## Best Practices Summary

### 1. API Selection
- **NewAPI Format** (`/v1/video/generations`): Suitable for scenarios requiring more custom parameters
- **OpenAI Format** (`/v1/videos`): Suitable for scenarios integrating with the OpenAI ecosystem

### 2. Error Handling
- Implement exponential backoff retry mechanism
- Distinguish between transient and permanent errors
- Provide meaningful error messages

### 3. Performance Optimization
- Control the number of concurrent requests
- Implement an appropriate caching strategy
- Monitor API call performance

### 4. User Experience
- Provide progress feedback
- Implement timeout handling
- Support cancellation operations

### 5. Resource Management
- Download generated videos promptly
- Clean up temporary files
- Monitor storage usage

These best practices can help you build stable and efficient video generation applications.