# 🌐 文档自动翻译系统

本项目已配置完整的文档自动翻译系统，可以自动将中文文档翻译为英文和日文。

## ✨ 特性

- 🤖 **自动化翻译**: 使用 GitHub Actions 自动检测文档变更并翻译
- 🌍 **多语言支持**: 支持英文 (EN) 和日文 (JA) 翻译
- 🎯 **智能识别**: 只翻译变更的文档，节省 API 调用
- 📝 **格式保持**: 保持 Markdown 格式完整，代码块不翻译
- 🔄 **灵活配置**: 支持自定义 API 端点和模型选择
- ⚡ **手动触发**: 支持手动触发全量翻译

## 📁 项目结构

```
new-api-docs/
├── .github/
│   └── workflows/
│       ├── translate-docs.yml    # GitHub Actions 工作流配置
│       └── README.md             # 工作流详细说明
├── docs/                         # 中文原文档（源文件）
│   ├── index.md
│   ├── getting-started.md
│   ├── en/                       # 英文翻译（自动生成）
│   │   ├── index.md
│   │   └── getting-started.md
│   └── ja/                       # 日文翻译（自动生成）
│       ├── .gitkeep
│       └── ...
├── docs_assistant/
│   ├── translate.py              # 翻译脚本
│   ├── requirements.txt          # Python 依赖
│   └── README.md                 # 脚本使用说明
└── mkdocs.yml                    # MkDocs 配置（含多语言设置）
```

## 🚀 快速开始

### 1. 配置 GitHub Secrets

在 GitHub 仓库设置中添加以下 Secrets：

1. 进入 **Settings** → **Secrets and variables** → **Actions**
2. 点击 **New repository secret**
3. 添加以下 Secret：

#### 必需配置

| Secret 名称 | 说明 | 示例 |
|------------|------|------|
| `OPENAI_API_KEY` | OpenAI API 密钥 | `sk-proj-...` |

#### 可选配置

| Secret 名称 | 说明 | 默认值 |
|------------|------|--------|
| `OPENAI_BASE_URL` | API 基础 URL | `https://api.openai.com/v1` |
| `OPENAI_MODEL` | 使用的模型 | `gpt-4o-mini` |
| `MAX_RETRIES` | 最大重试次数 | `3` |
| `RETRY_DELAY` | 初始重试延迟（秒） | `2` |
| `RETRY_BACKOFF` | 重试延迟退避倍数 | `2.0` |

### 2. 开始使用

配置完成后，系统将自动工作：

```bash
# 1. 编辑或创建中文文档
vim docs/new-feature.md

# 2. 提交并推送到 main 分支
git add docs/new-feature.md
git commit -m "添加新功能文档"
git push origin main

# 3. GitHub Actions 自动运行
#    ✅ 检测到文档变更
#    ✅ 翻译为英文 → docs/en/new-feature.md
#    ✅ 翻译为日文 → docs/ja/new-feature.md
#    ✅ 自动提交翻译结果

# 4. 稍后拉取更新
git pull
```

### 3. 手动触发翻译

如果需要重新翻译所有文档：

1. 进入 **Actions** 标签页
2. 选择 **Auto Translate Documentation**
3. 点击 **Run workflow**
4. 勾选 **强制翻译所有文档**
5. 点击 **Run workflow** 按钮

## 📖 使用场景

### 场景 1：更新现有文档

```bash
# 修改中文文档
vim docs/guide/getting-started.md

# 提交推送
git add docs/guide/getting-started.md
git commit -m "更新快速开始指南"
git push

# ✅ 系统自动更新 docs/en/guide/getting-started.md
# ✅ 系统自动更新 docs/ja/guide/getting-started.md
```

### 场景 2：添加新文档

```bash
# 创建新的中文文档
vim docs/api/new-endpoint.md

# 提交推送
git add docs/api/new-endpoint.md
git commit -m "添加新 API 端点文档"
git push

# ✅ 系统自动创建 docs/en/api/new-endpoint.md
# ✅ 系统自动创建 docs/ja/api/new-endpoint.md
```

### 场景 3：批量更新

```bash
# 修改多个文档
git add docs/guide/*.md
git commit -m "更新所有指南文档"
git push

# ✅ 系统自动翻译所有变更的文档
```

## 🔧 本地开发与测试

### 安装依赖

```bash
cd docs_assistant
pip install -r requirements.txt
```

### 配置环境变量

```bash
export OPENAI_API_KEY="your-api-key"
export OPENAI_BASE_URL="https://api.openai.com/v1"
export OPENAI_MODEL="gpt-4o-mini"

# 重试配置（可选）
export MAX_RETRIES="3"
export RETRY_DELAY="2"
export RETRY_BACKOFF="2.0"
```

### 测试翻译

```bash
# 翻译单个文件
python translate.py ../docs/getting-started.md

# 翻译多个文件
python translate.py ../docs/getting-started.md ../docs/guide/index.md

# 批量翻译
find ../docs/guide -name "*.md" -type f ! -path "*/en/*" ! -path "*/ja/*" | xargs python translate.py
```

### 成本示例（使用 gpt-4o-mini）

假设一个中等长度的文档（约 2000 tokens）：

- **单次翻译成本**: ~$0.003（翻译为 2 种语言）
- **100 篇文档**: ~$0.30
- **1000 篇文档**: ~$3.00

> 💡 **提示**: 由于只翻译变更的文档，实际成本通常很低。

## 🔄 可靠性保障

### 智能重试机制

脚本内置了强大的重试机制，确保翻译的可靠性：

✅ **自动重试**
- 网络超时自动重试
- API 限流自动退避
- 临时错误自动恢复

✅ **指数退避策略**
- 第 1 次重试：等待 2 秒
- 第 2 次重试：等待 4 秒
- 第 3 次重试：等待 8 秒
- 避免频繁请求造成更多限流

✅ **详细日志**
- 记录每次重试的原因
- 显示等待时间和剩余次数
- 便于问题诊断和追踪

✅ **超时保护**
- 每次 API 调用 60 秒超时
- 避免长时间等待
- 自动进入重试流程

### 配置建议

**网络稳定环境：**
```bash
MAX_RETRIES=3        # 默认配置
RETRY_DELAY=2
RETRY_BACKOFF=2.0
```

**不稳定网络环境：**
```bash
MAX_RETRIES=5        # 增加重试次数
RETRY_DELAY=3        # 增加初始延迟
RETRY_BACKOFF=2.0
```

**高频率翻译场景：**
```bash
MAX_RETRIES=3
RETRY_DELAY=5        # 增加延迟避免限流
RETRY_BACKOFF=3.0    # 更激进的退避
```

## 🎯 翻译质量控制

### 自动处理

脚本会自动处理以下内容：

✅ **保留原样**
- 代码块（\`\`\`code\`\`\`）
- 行内代码（\`code\`）
- URL 链接
- 图片路径
- 专有名词（New API、Cherry Studio 等）

✅ **智能翻译**
- 标题和正文
- 列表项
- 表格内容
- 引用块

### 质量检查清单

翻译完成后，建议检查：

- [ ] 技术术语翻译是否准确
- [ ] 代码示例是否保持完整
- [ ] 链接是否正常工作
- [ ] 格式是否保持一致
- [ ] 专有名词是否保持不变

## 🐛 故障排查

### 问题：工作流失败

**检查项：**
1. ✅ GitHub Secrets 是否正确配置
2. ✅ API 密钥是否有效
3. ✅ API 账户余额是否充足
4. ✅ 查看 Actions 日志了解详细错误

### 问题：翻译未触发

**可能原因：**
- 修改的文件不在 `docs/**/*.md` 路径下
- 修改的是已翻译文件（`docs/en/` 或 `docs/ja/`）
- 提交消息包含 `[skip ci]`

### 问题：翻译质量不佳

**解决方案：**
1. 使用更高级的模型（如 `gpt-4o`）
2. 改进中文原文的表达
3. 手动调整翻译结果
4. 在 GitHub Issues 中反馈问题

## 📚 相关文档

- [GitHub Actions 工作流说明](.github/workflows/README.md) - 工作流配置和使用
- [翻译脚本使用指南](docs_assistant/README.md) - 本地脚本使用方法
- [MkDocs i18n 插件文档](https://github.com/ultrabug/mkdocs-static-i18n) - 多语言插件
- [OpenAI API 文档](https://platform.openai.com/docs/api-reference) - API 参考

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进翻译系统！

### 改进方向

- 添加更多语言支持（韩语、西班牙语等）
- 实现翻译缓存以减少 API 调用
- 添加翻译质量评分系统
- 支持增量翻译（只翻译变更部分）
- 添加人工校对工作流

## 📄 许可证

本翻译系统遵循项目主仓库的许可证。

---

**需要帮助？** 请在 [GitHub Issues](https://github.com/QuantumNous/new-api-docs/issues) 中提问。

