# 🌐 文档自动翻译工作流

这个 GitHub Actions 工作流会在文档更新时自动使用 OpenAI API 将中文文档翻译为英文和日文。

## 📋 功能特性

- ✅ 自动检测文档变更
- ✅ 使用 OpenAI API 进行高质量翻译
- ✅ 支持英文 (EN) 和日文 (JA) 翻译
- ✅ 保持 Markdown 格式完整
- ✅ 自动提交翻译结果
- ✅ 支持手动触发全量翻译

## ⚙️ 配置步骤

### 1. 设置 GitHub Secrets

在你的 GitHub 仓库中，需要配置以下 Secrets：

1. 进入仓库的 **Settings** → **Secrets and variables** → **Actions**
2. 添加以下 Secrets：

| Secret 名称 | 说明 | 必需 | 示例值 |
|------------|------|------|--------|
| `OPENAI_API_KEY` | OpenAI API 密钥 | ✅ 是 | `sk-...` |
| `OPENAI_BASE_URL` | OpenAI API 基础 URL | ❌ 否 | `https://api.openai.com/v1` (默认值) |
| `OPENAI_MODEL` | 使用的模型名称 | ❌ 否 | `gpt-4o-mini` (默认值) |
| `MAX_RETRIES` | 翻译失败时的最大重试次数 | ❌ 否 | `3` (默认值) |
| `RETRY_DELAY` | 初始重试延迟（秒） | ❌ 否 | `2` (默认值) |
| `RETRY_BACKOFF` | 重试延迟的退避倍数 | ❌ 否 | `2.0` (默认值) |

### 2. 配置 New API（可选）

如果你使用 New API 等 API 网关服务，可以配置自定义的 Base URL：

```
OPENAI_BASE_URL=https://your-newapi-domain.com/v1
OPENAI_API_KEY=your-api-key
OPENAI_MODEL=gpt-4o-mini
```

### 3. 配置重试策略（可选）

系统默认会在翻译失败时自动重试，你可以自定义重试策略：

```
MAX_RETRIES=3        # 最大重试次数（默认 3）
RETRY_DELAY=2        # 初始延迟秒数（默认 2）
RETRY_BACKOFF=2.0    # 延迟倍数（默认 2.0）
```

**重试机制说明：**
- 采用指数退避策略，每次重试的延迟时间会递增
- 第 1 次重试：等待 2 秒
- 第 2 次重试：等待 4 秒（2 × 2.0）
- 第 3 次重试：等待 8 秒（2 × 2.0²）
- 如果所有重试都失败，则抛出错误

## 🚀 使用方法

### 自动触发

工作流会在以下情况自动运行：

1. 当你推送更改到 `main` 分支
2. 且修改了 `docs/**/*.md` 文件（不包括 `docs/en/` 和 `docs/ja/`）

**示例工作流程：**

```bash
# 1. 编辑中文文档
vim docs/guide/getting-started.md

# 2. 提交并推送
git add docs/guide/getting-started.md
git commit -m "更新快速开始指南"
git push origin main

# 3. GitHub Actions 会自动：
#    - 检测到文档变更
#    - 翻译为英文和日文
#    - 将翻译文件提交到 docs/en/ 和 docs/ja/
```

### 手动触发

你也可以手动触发工作流来强制翻译所有文档：

1. 进入 **Actions** 标签页
2. 选择 **Auto Translate Documentation** 工作流
3. 点击 **Run workflow**
4. 勾选 **强制翻译所有文档** 选项
5. 点击 **Run workflow** 按钮

这会翻译所有中文文档，无论是否有变更。

## 📁 文件结构

```
docs/
├── index.md                   # 中文原文
├── getting-started.md         # 中文原文
├── en/                        # 英文翻译（自动生成）
│   ├── index.md
│   └── getting-started.md
└── ja/                        # 日文翻译（自动生成）
    ├── index.md
    └── getting-started.md
```

## 🔍 工作流程详解

1. **触发条件检查**: 检查是否有中文文档被修改
2. **环境准备**: 安装 Python 和必要的依赖
3. **变更检测**: 识别哪些文档需要翻译
4. **翻译处理**: 
   - 使用 OpenAI API 翻译文档
   - 保持 Markdown 格式
   - 保留代码块不翻译
   - 保持专有名词不变
5. **提交结果**: 自动提交翻译后的文件到仓库

## 📊 翻译质量保证

翻译脚本包含以下质量保证措施：

- ✅ 保持 Markdown 语法完整（标题、列表、链接等）
- ✅ 代码块内容不翻译
- ✅ 图片路径和链接保持不变
- ✅ 专业术语使用行业标准翻译
- ✅ 专有名词（如 "New API"、"Cherry Studio"）保持不变
- ✅ 使用较低温度参数 (0.3) 以获得更一致的翻译

## 🐛 故障排查

### 问题：工作流失败

**可能原因：**
- OpenAI API 密钥未配置或无效
- API 配额用尽
- 网络连接问题

**解决方法：**
1. 检查 GitHub Secrets 配置
2. 验证 API 密钥是否有效
3. 检查 API 账户余额
4. 查看 Actions 日志获取详细错误信息

### 问题：翻译质量不佳

**解决方法：**
1. 尝试使用更高级的模型（如 `gpt-4o`）
2. 检查原文是否清晰准确
3. 手动调整翻译后的文件

### 问题：某些文件未被翻译

**可能原因：**
- 文件路径在 `docs/en/` 或 `docs/ja/` 下（这些会被自动跳过）
- 文件不是 `.md` 格式
- 没有检测到文件变更

**解决方法：**
- 使用手动触发模式强制翻译所有文档

## 💡 最佳实践

1. **先写好中文文档**: 确保中文文档质量，这会直接影响翻译质量
2. **使用标准 Markdown**: 遵循标准 Markdown 语法以确保格式正确
3. **批量提交**: 一次性修改多个文档后提交，可以减少 API 调用次数
4. **检查翻译结果**: 自动翻译后，建议人工检查重要文档的翻译质量
5. **成本控制**: 根据需要选择合适的模型，在质量和成本之间平衡

## 📝 本地测试

你也可以在本地运行翻译脚本：

```bash
# 设置环境变量
export OPENAI_API_KEY="your-api-key"
export OPENAI_BASE_URL="https://api.openai.com/v1"
export OPENAI_MODEL="gpt-4o-mini"

# 翻译单个文件
python docs_assistant/translate.py docs/getting-started.md

# 翻译多个文件
python docs_assistant/translate.py docs/getting-started.md docs/guide/index.md
```

## 🔗 相关链接

- [OpenAI API 文档](https://platform.openai.com/docs/api-reference)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [MkDocs i18n 插件](https://github.com/ultrabug/mkdocs-static-i18n)

## 📄 许可证

本工作流遵循项目主仓库的许可证。

