# 📚 New API Docs

## 🚀 本地开发步骤

### 1️⃣ 安装依赖

```bash
pip install mkdocs-material
```

### 2️⃣ 启动本地服务

```bash
mkdocs serve
```

启动成功后访问
中文版: http://127.0.0.1:8000
英文版: http://127.0.0.1:8000/en/
日文版: http://127.0.0.1:8000/ja/

## 🌐 自动翻译

本项目配置了 GitHub Actions 自动翻译工作流，可以自动将中文文档翻译为英文和日文。

### 配置方法

1. 在 GitHub 仓库的 **Settings** → **Secrets and variables** → **Actions** 中添加以下 Secrets：
   - `OPENAI_API_KEY`: OpenAI API 密钥（必需）
   - `OPENAI_BASE_URL`: API 基础 URL（可选，默认: `https://api.openai.com/v1`）
   - `OPENAI_MODEL`: 使用的模型（可选，默认: `gpt-4o-mini`）

2. 当你修改 `docs/` 目录下的中文文档并推送到 `main` 分支时，GitHub Actions 会自动：
   - 检测变更的文件
   - 使用 OpenAI API 翻译为英文和日文
   - 自动提交翻译结果到 `docs/en/` 和 `docs/ja/`

### 手动触发

你也可以在 Actions 页面手动触发工作流，强制翻译所有文档。

详细说明请查看: [.github/workflows/README.md](.github/workflows/README.md)

## 📄 许可 / License

- **文档内容（`docs/` 及其下图片/图表等）**: 使用 **CC0 1.0（公有领域贡献）**。
  - 许可文本: [https://creativecommons.org/publicdomain/zero/1.0/](https://creativecommons.org/publicdomain/zero/1.0/)
- **代码与脚本（如 `docs_assistant/` 等）**: 使用 **MIT License**。
  - 许可文本: [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)
- **商标与 Logo (如所有favicon.ico、logo.png等)**: 不在开源许可范围内，保留所有权利。

- EN: Documentation is licensed under **CC0 1.0**; code is licensed under **MIT**. Trademarks and logos are excluded from the open-source licenses.
