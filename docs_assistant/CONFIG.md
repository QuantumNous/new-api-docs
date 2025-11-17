# ⚙️ 配置指南

## 环境变量配置

文档更新服务通过 `docker-compose.yml` 中的环境变量进行配置。

### GitHub 配置（必需）

#### GITHUB_REPO
- **说明**：GitHub 仓库名称
- **格式**：`owner/repo`
- **示例**：`QuantumNous/new-api`

#### GITHUB_TOKEN（强烈推荐）
- **说明**：GitHub Personal Access Token
- **为什么重要**：提升 API 速率限制
  - ❌ 不使用 Token：60 次/小时（容易触发限制）
  - ✅ 使用 Token：5000 次/小时（充足使用）

**如何获取 GitHub Token：**

1. 访问 [GitHub Settings - Tokens](https://github.com/settings/tokens)
2. 点击 **"Generate new token (classic)"**
3. 设置 Token 名称（如：`docs-updater`）
4. **选择权限**：只需勾选 ✅ `public_repo`
5. 点击 **"Generate token"** 并立即复制
6. 在 `docker-compose.yml` 中设置：
   ```yaml
   environment:
     - GITHUB_TOKEN=ghp_your_token_here
   ```

⚠️ **安全提示**：
- Token 具有访问权限，请妥善保管
- 不要将包含真实 Token 的文件提交到 Git
- 如果 Token 泄露，请立即在 GitHub 删除并重新生成

### GitHub 代理配置（可选）

#### USE_PROXY
- **说明**：是否使用代理访问 GitHub
- **默认值**：`true`
- **可选值**：`true` / `false`

#### GITHUB_PROXY
- **说明**：代理服务器地址
- **示例**：`https://ghproxy.com`
- **留空表示**：不使用代理或使用默认代理

### 爱发电配置（可选）

用于获取赞助者信息并显示在文档中。

#### AFDIAN_USER_ID
- **说明**：爱发电用户ID
- **获取方式**：登录爱发电后台查看

#### AFDIAN_TOKEN
- **说明**：爱发电 API Token
- **获取方式**：爱发电后台 → 开发者设置

### 更新配置

#### UPDATE_INTERVAL
- **说明**：更新检查间隔（秒）
- **默认值**：`1800`（30分钟）
- **说明**：
  - 贡献者列表：每 3600 秒（1小时）更新
  - 发布日志：每 1800 秒（30分钟）更新
  - 此参数控制服务多久检查一次是否需要更新

#### DOCS_DIR
- **说明**：文档目录路径（Docker 容器内）
- **默认值**：`/app/docs`
- **通常不需要修改**

#### TZ
- **说明**：时区设置
- **默认值**：`Asia/Shanghai`
- **可选值**：任何有效的时区字符串（如 `UTC`, `America/New_York`）

## 完整配置示例

```yaml
# docker-compose.yml 中的配置示例
environment:
  # 必需配置
  - GITHUB_REPO=QuantumNous/new-api
  - GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx  # 强烈推荐设置
  
  # 可选配置
  - UPDATE_INTERVAL=1800
  - USE_PROXY=true
  - GITHUB_PROXY=
  - AFDIAN_USER_ID=
  - AFDIAN_TOKEN=
  - DOCS_DIR=/app/docs
  - TZ=Asia/Shanghai
```

## 故障排查

### 问题：频繁遇到 "GitHub API限制已达到"

**原因**：未设置 `GITHUB_TOKEN`，使用匿名访问限制为 60次/小时

**解决方案**：
1. 按照上述步骤获取 GitHub Token
2. 在 `docker-compose.yml` 中设置 `GITHUB_TOKEN`
3. 重启服务：`docker-compose restart docs-updater`

### 问题：无法访问 GitHub API

**原因**：网络限制或代理配置问题

**解决方案**：
1. 检查 `USE_PROXY` 设置
2. 如果在中国大陆，设置 `USE_PROXY=true` 和合适的 `GITHUB_PROXY`
3. 推荐代理服务：
   - `https://ghproxy.com`
   - `https://mirror.ghproxy.com`

### 问题：服务启动后立即退出

**原因**：配置错误或依赖缺失

**解决方案**：
1. 查看日志：`docker-compose logs docs-updater`
2. 检查仓库名称格式是否正确
3. 确认所有必需的配置都已设置

## 日志查看

```bash
# 查看实时日志
docker-compose logs -f docs-updater

# 查看最近100行日志
docker-compose logs --tail=100 docs-updater

# 查看特定时间的日志
docker-compose logs --since 2024-01-01T10:00:00 docs-updater
```

## 服务管理

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose stop docs-updater

# 重启服务（修改配置后）
docker-compose restart docs-updater

# 重新构建并启动（修改代码后）
docker-compose up -d --build docs-updater

# 停止并删除容器
docker-compose down
```

