# 分组模块

!!! info "功能说明"
    接口前缀统一为 http(s)://`<your-domain>`

    生产环境应使用 HTTPS 以保证认证令牌。 HTTP 仅建议用于开发环境。

    简单的分组名称查询接口 。主要用于管理员界面的下拉选择组件，与用户端的分组接口不同，仅返回名称列表而不包含倍率等详细信息。

## 🔐 管理员鉴权

### 获取全部分组列表

- **接口名称**：获取全部分组列表
- **HTTP 方法**：GET
- **路径**：`/api/group/`
- **鉴权要求**：管理员
- **功能简介**：获取系统中所有用户分组的名称列表，用于管理员配置和前端组件选择

💡 请求示例：

```
const response = await fetch('/api/group/', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token'  
    'New-Api-User': 'Bearer your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功响应示例：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    "default",  
    "vip",  
    "premium",  
    "enterprise"  
  ]  
}
```

❗ 失败响应示例：

```
{  
  "success": false,  
  "message": "获取分组列表失败"  
}
```

🧾 字段说明：

`data` （数组）: 分组名称列表，包含系统中所有已配置的用户分组名称
