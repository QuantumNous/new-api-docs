# 令牌用量查询（Token Usage）

!!! info "功能说明"
    通过认证查询当前 Bearer Token 的额度使用情况：授予总量、已用、剩余、是否无限、模型限额及到期时间。

## 📮 端点

```
GET /api/usage/token
```

- 需要在请求头中携带鉴权信息
- 仅返回当前请求所使用的 Token 的用量信息

## 🔐 鉴权

在请求头中包含以下内容进行 API 密钥认证：

```
Authorization: Bearer $NEWAPI_API_KEY
```

- 支持携带或不携带 `sk-` 前缀，服务端会自动兼容
- 缺少或无效的 Authorization 头将返回 401

## 💡 请求示例

```bash
curl -X GET https://你的newapi服务器地址/api/usage/token \
  -H "Authorization: Bearer $NEWAPI_API_KEY"
```

## ✅ 成功响应示例

```json
{
  "code": true,
  "message": "ok",
  "data": {
    "object": "token_usage",
    "name": "Default Token",
    "total_granted": 1000000,
    "total_used": 12345,
    "total_available": 987655,
    "unlimited_quota": false,
    "model_limits": {
      "gpt-4o-mini": 500000
    },
    "model_limits_enabled": false,
    "expires_at": 0
  }
}
```

## ❗ 错误响应示例

- 缺少鉴权头：

```json
{
  "success": false,
  "message": "No Authorization header"
}
```

- 非 Bearer 方案：

```json
{
  "success": false,
  "message": "Invalid Bearer token"
}
```

- Token 查找失败（例如无效或已删除）：

```json
{
  "success": false,
  "message": "token not found"
}
```

## 🧾 字段说明（data）

- `object`: 固定为 `token_usage`
- `name`: 令牌名称
- `total_granted`: 授予总量（= 已用 + 剩余）
- `total_used`: 已使用额度
- `total_available`: 可用剩余额度
- `unlimited_quota`: 是否为无限额度
- `model_limits`: 针对不同模型的次数/额度限制映射
- `model_limits_enabled`: 是否启用模型限额
- `expires_at`: 到期时间的 Unix 时间戳（秒）。若永不过期返回 `0`（由后端将 `-1` 归一化为 `0`）

---

> 参考实现：`GET /api/usage/token` 新增于 PR [#1161](https://github.com/QuantumNous/new-api/pull/1161)
