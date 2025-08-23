# Token Usage Query

!!! info "What it does"
    Retrieve the current Bearer token's quota usage: total granted, used, available, unlimited flag, model limits and expiration time.

## 📮 Endpoint

```
GET /api/usage/token
```

- Requires Authorization header
- Returns usage info for the token used in the current request

## 🔐 Authentication

Include the following header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

- `sk-` prefix is accepted but optional; the server normalizes it
- Missing or invalid Authorization header returns 401

## 💡 Request Example

```bash
curl -X GET https://your-newapi-server-address/api/usage/token \
  -H "Authorization: Bearer $NEWAPI_API_KEY"
```

## ✅ Success Response Example

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

## ❗ Error Response Examples

- Missing Authorization header:

```json
{
  "success": false,
  "message": "No Authorization header"
}
```

- Invalid scheme (non-Bearer):

```json
{
  "success": false,
  "message": "Invalid Bearer token"
}
```

- Token fetch failed (e.g., invalid or deleted):

```json
{
  "success": false,
  "message": "token not found"
}
```

## 🧾 Field Descriptions (data)

- `object`: Always `token_usage`
- `name`: Token name
- `total_granted`: Total granted (= used + available)
- `total_used`: Used quota
- `total_available`: Remaining available quota
- `unlimited_quota`: Whether the token has unlimited quota
- `model_limits`: Per-model quota limits map
- `model_limits_enabled`: Whether model-specific limits are enabled
- `expires_at`: Expiration Unix timestamp in seconds. `0` means never expires (backend normalizes `-1` → `0`).

---

> Reference: `GET /api/usage/token` added in PR [#1161](https://github.com/QuantumNous/new-api/pull/1161)
