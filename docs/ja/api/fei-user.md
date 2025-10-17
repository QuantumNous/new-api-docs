# ユーザーモジュール

!!! info "機能説明"
    インターフェースプレフィックスは http(s)://`<your-domain>` に統一されています。

    本番環境では認証トークンを保護するために HTTPS を使用する必要があります。HTTP は開発環境でのみ推奨されます。

    コアユーザー管理システムであり、4段階の権限体系（公開/ユーザー/管理者/Root）と完全なユーザーライフサイクル管理を実現します。登録、ログイン、個人プロファイル、トークン管理、チャージ/支払い、アフィリエイトシステムなどの機能を含みます。2FA、メール認証、および複数の OAuth ログイン方法をサポートしています。

## アカウント登録/ログイン

### 🔐 認証不要

#### 新規アカウントの登録

- **インターフェース名**：新規アカウントの登録
- **HTTP メソッド**：POST
- **パス**：`/api/user/register`
- **認証要件**：公開
- **機能概要**：新規ユーザーアカウントを作成します。メール認証と紹介コード機能をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/user/register', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json'  
  },  
  body: JSON.stringify({  
    username: "newuser",  
    password: "password123",  
    email: "user@example.com",  
    verification_code: "123456",  
    aff_code: "INVITE123"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "用户注册成功"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "管理员关闭了新用户注册"  
}
```

🧾 フィールドの説明：

- `username` （文字列）: ユーザー名。必須
- `password` （文字列）: パスワード。必須
- `email` （文字列）: メールアドレス。メール認証が有効な場合に必須
- `verification_code` （文字列）: メール認証コード。メール認証が有効な場合に必須
- `aff_code` （文字列）: 紹介コード。オプション

#### ユーザーログイン

- **インターフェース名**：ユーザーログイン
- **HTTP メソッド**：POST
- **パス**：`/api/user/login`
- **認証要件**：公開
- **機能概要**：ユーザーアカウントログイン。2要素認証（2FA）をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/user/login', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json'  
  },  
  body: JSON.stringify({  
    username: "testuser",  
    password: "password123"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例（2FAなし）：

```
{  
  "success": true,  
  "message": "登录成功",  
  "data": {  
    "token": "user_access_token",  
    "user": {  
      "id": 1,  
      "username": "testuser",  
      "role": 1,  
      "quota": 1000000  
    }  
  }  
}
```

✅ 成功レスポンス例（2FAが必要）：

```
{  
  "success": true,  
  "message": "请输入两步验证码",  
  "data": {  
    "require_2fa": true  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "管理员关闭了密码登录"  
}
```

🧾 フィールドの説明：

- `username` （文字列）: ユーザー名。必須
- `password` （文字列）: パスワード。必須
- `require_2fa` （ブール型）: 2要素認証が必要かどうか

#### Epay 支払いコールバック

- **インターフェース名**：Epay 支払いコールバック
- **HTTP メソッド**：GET
- **パス**：`/api/user/epay/notify`
- **認証要件**：公開
- **機能概要**：Epay（易支付）システムの支払いコールバック通知を処理します。

💡 リクエスト例：

```
_// 通常由支付系统自动回调，前端无需主动调用  _
_// 示例URL: /api/user/epay/notify?trade_no=USR1NO123456&money=10.00&trade_status=TRADE_SUCCESS_
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "支付成功"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "订单不存在或已处理"  
}
```

🧾 フィールドの説明：

- `trade_no` （文字列）: 取引注文番号
- `money` （文字列）: 支払い金額
- `trade_status` （文字列）: 取引ステータス
- `sign` （文字列）: 署名検証

#### すべてのグループをリスト表示（認証不要版）

- **インターフェース名**：すべてのグループをリスト表示
- **HTTP メソッド**：GET
- **パス**：`/api/user/groups`
- **認証要件**：公開
- **機能概要**：システム内のすべてのユーザーグループ情報を取得します。ログインなしでアクセス可能です。

💡 リクエスト例：

```
const response = await fetch('/api/user/groups', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json'  
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "default": {  
      "ratio": 1.0,  
      "desc": "默认分组"  
    },  
    "vip": {  
      "ratio": 0.8,  
      "desc": "VIP分组"  
    },  
    "auto": {  
      "ratio": "自动",  
      "desc": "自动选择最优分组"  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取分组信息失败"  
}
```

🧾 フィールドの説明：

`data` （オブジェクト）: グループ情報マップ

- キー （文字列）: グループ名
- `ratio` （数値/文字列）: グループ倍率。「自動」は自動選択を意味します
- `desc` （文字列）: グループの説明

### 🔐 ユーザー認証

#### ログアウト

- **インターフェース名**：ログアウト
- **HTTP メソッド**：GET
- **パス**：`/api/user/logout`
- **認証要件**：ユーザー
- **機能概要**：ユーザーセッションをクリアし、ログアウト状態にします。

💡 リクエスト例：

```
const response = await fetch('/api/user/logout', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "会话清除失败"  
}
```

🧾 フィールドの説明：

リクエストパラメータなし

## ユーザー自身の操作

### 🔐 ユーザー認証

#### 自身が所属するグループの取得

- **インターフェース名**：自身が所属するグループの取得
- **HTTP メソッド**：GET
- **パス**：`/api/user/self/groups`
- **認証要件**：ユーザー
- **機能概要**：現在ログインしているユーザーが利用可能なグループ情報を取得します。グループ倍率と説明が含まれます。

💡 リクエスト例：

```
const response = await fetch('/api/user/self/groups', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "default": {  
      "ratio": 1.0,  
      "desc": "默认分组"  
    },  
    "vip": {  
      "ratio": 0.8,  
      "desc": "VIP分组"  
    },  
    "auto": {  
      "ratio": "自动",  
      "desc": "自动选择最优分组"  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取分组信息失败"  
}
```

🧾 フィールドの説明：

`data` （オブジェクト）: ユーザーが利用可能なグループ情報マップ group.go：25-48

- キー （文字列）: グループ名
- `ratio` （数値/文字列）: グループ倍率。「自動」は最適なグループの自動選択を意味します
- `desc` （文字列）: グループの説明

#### 個人プロファイルの取得

- **インターフェース名**：個人プロファイルの取得
- **HTTP メソッド**：GET
- **パス**：`/api/user/self`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーの詳細情報（権限、クォータ、設定など）を取得します。

💡 リクエスト例：

```
const response = await fetch('/api/user/self', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "id": 1,  
    "username": "testuser",  
    "display_name": "Test User",  
    "role": 1,  
    "status": 1,  
    "email": "user@example.com",  
    "group": "default",  
    "quota": 1000000,  
    "used_quota": 50000,  
    "request_count": 100,  
    "aff_code": "ABC123",  
    "aff_count": 5,  
    "aff_quota": 10000,  
    "aff_history_quota": 50000,  
    "inviter_id": 0,  
    "linux_do_id": "",  
    "setting": "{}",  
    "stripe_customer": "",  
    "sidebar_modules": "{\"chat\":{\"enabled\":true}}",  
    "permissions": {  
      "can_view_logs": true,  
      "can_manage_tokens": true  
    }  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取用户信息失败"  
}
```

🧾 フィールドの説明：

- `id` （数値）: ユーザー ID
- `username` （文字列）: ユーザー名
- `display_name` （文字列）: 表示名
- `role` （数値）: ユーザーロール。1=一般ユーザー、10=管理者、100=Root ユーザー
- `status` （数値）: ユーザーの状態。1=正常、2=無効
- `email` （文字列）: メールアドレス
- `group` （文字列）: 所属グループ
- `quota` （数値）: 総クォータ
- `used_quota` （数値）: 使用済みクォータ
- `request_count` （数値）: リクエスト回数
- `aff_code` （文字列）: 紹介コード
- `aff_count` （数値）: 紹介人数
- `aff_quota` （数値）: 紹介ボーナスクォータ
- `aff_history_quota` （数値）: 履歴上の紹介クォータ
- `inviter_id` （数値）: 招待者 ID
- `linux_do_id` （文字列）: LinuxDo アカウント ID
- `setting` （文字列）: ユーザー設定の JSON 文字列
- `stripe_customer` （文字列）: Stripe 顧客 ID
- `sidebar_modules` （文字列）: サイドバーモジュール設定の JSON 文字列
- `permissions` （オブジェクト）: ユーザー権限情報

#### モデルの可視性の取得

- **インターフェース名**：モデルの可視性の取得
- **HTTP メソッド**：GET
- **パス**：`/api/user/models`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーがアクセス可能な AI モデルのリストを取得します。

💡 リクエスト例：

```
const response = await fetch('/api/user/models', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": [  
    "gpt-3.5-turbo",  
    "gpt-4",  
    "claude-3-sonnet",  
    "claude-3-haiku"  
  ]  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取模型列表失败"  
}
```

🧾 フィールドの説明：

`data` （配列）: ユーザーがアクセス可能なモデル名のリスト

#### 個人プロファイルの変更

- **インターフェース名**：個人プロファイルの変更
- **HTTP メソッド**：PUT
- **パス**：`/api/user/self`
- **認証要件**：ユーザー
- **機能概要**：ユーザーの個人情報またはサイドバー設定を更新します。

💡 リクエスト例（個人情報の更新）：

```
const response = await fetch('/api/user/self', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    display_name: "New Display Name",  
    email: "newemail@example.com"  
  })  
});  
const data = await response.json();
```

💡 リクエスト例（サイドバー設定の更新）：

```
const response = await fetch('/api/user/self', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    sidebar_modules: JSON.stringify({  
      chat: { enabled: true, playground: true },  
      console: { enabled: true, token: true }  
    })  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "更新成功"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "输入不合法"  
}
```

🧾 フィールドの説明：

- `display_name` （文字列）: 表示名。オプション
- `email` （文字列）: メールアドレス。オプション
- `password` （文字列）: 新しいパスワード。オプション
- `sidebar_modules` （文字列）: サイドバーモジュール設定の JSON 文字列。オプション

#### アカウントの削除

- **インターフェース名**：アカウントの削除
- **HTTP メソッド**：DELETE
- **パス**：`/api/user/self`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザーアカウントを削除します。Root ユーザーは削除できません。

💡 リクエスト例：

```
const response = await fetch('/api/user/self', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "不能删除超级管理员账户"  
}
```

🧾 フィールドの説明：

リクエストパラメータなし

#### ユーザーレベルのアクセストークンの生成

- **インターフェース名**：ユーザーレベルのアクセストークンの生成
- **HTTP メソッド**：GET
- **パス**：`/api/user/token`
- **認証要件**：ユーザー
- **機能概要**：現在のユーザー向けに新しいアクセス**トークン**を生成し、API 呼び出しに使用します。

💡 リクエスト例：

```
const response = await fetch('/api/user/token', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": "<YOUR_API_KEY>"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "生成令牌失败"  
}
```

🧾 フィールドの説明：

`data` （文字列）: 生成されたアクセストークン

#### 紹介コード情報の取得

- **インターフェース名**：紹介コード情報の取得
- **HTTP メソッド**：GET
- **パス**：`/api/user/aff`
- **認証要件**：ユーザー
- **機能概要**：ユーザーの紹介コードを取得または生成します。新規ユーザーの招待に使用されます。

💡 リクエスト例：

```
const response = await fetch('/api/user/aff', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": "ABC123"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取推广码失败"  
}
```

🧾 フィールドの説明：

`data` （文字列）: ユーザーの紹介コード。存在しない場合は自動的に 4 桁のランダムな文字列が生成されます

#### クォータの直接チャージ

- **インターフェース名**：クォータの直接チャージ
- **HTTP メソッド**：POST
- **パス**：`/api/user/topup`
- **認証要件**：ユーザー
- **機能概要**：交換コードを使用してアカウントに**クォータ**をチャージします。

💡 リクエスト例：

```
const response = await fetch('/api/user/topup', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    key: "REDEEM123456"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "兑换成功",  
  "data": 100000  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "兑换码无效或已使用"  
}
```

🧾 フィールドの説明：

- `key` （文字列）: 交換コード。必須
- `data` （数値）: 成功時に交換された**クォータ**数が返されます

#### 支払い注文の送信

- **インターフェース名**：支払い注文の送信
- **HTTP メソッド**：POST
- **パス**：`/api/user/pay`
- **認証要件**：ユーザー
- **機能概要**：オンライン支払い注文を作成します。複数の支払い方法をサポートしています。

💡 リクエスト例：

```
const response = await fetch('/api/user/pay', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    amount: 10000,  
    payment_method: "alipay",  
    top_up_code: ""  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "success",  
  "data": {  
    "pid": "12345",  
    "type": "alipay",  
    "out_trade_no": "USR1NO123456",  
    "notify_url": "https://example.com/notify",  
    "return_url": "https://example.com/return",  
    "name": "TUC10000",  
    "money": "10.00",  
    "sign": "abc123def456"  
  },  
  "url": "https://pay.example.com/submit"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "充值数量不能小于 1000"  
}
```

🧾 フィールドの説明：

- `amount` （数値）: チャージ数量。最小チャージ**額度**以上である必要があります topup.go：133-136
- `payment_method` （文字列）: 支払い方法（例："alipay"、"wxpay"など）
- `top_up_code` （文字列）: チャージコード。オプション
- `data` （オブジェクト）: 支払いフォームパラメータ
- `url` （文字列）: 支払い送信先アドレス

#### 支払い金額の計算

- **インターフェース名**：支払い金額の計算
- **HTTP メソッド**：POST
- **パス**：`/api/user/amount`
- **認証要件**：ユーザー
- **機能概要**：指定されたチャージ数量に対応する実際の支払い金額を計算します。

💡 リクエスト例：

```
const response = await fetch('/api/user/amount', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    amount: 10000,  
    top_up_code: ""  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "success",  
  "data": "10.00"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "充值数量不能小于 1000"  
}
```

🧾 フィールドの説明：

- `amount` （数値）: チャージ数量。最小チャージ**額度**以上である必要があります
- `top_up_code` （文字列）: チャージコード。オプション
- `data` （文字列）: 実際に支払う必要のある金額（元）

#### 紹介クォータの振り替え

- **インターフェース名**：紹介クォータの振り替え
- **HTTP メソッド**：POST
- **パス**：`/api/user/aff_transfer`
- **認証要件**：ユーザー
- **機能概要**：紹介ボーナス**クォータ**を使用可能な**クォータ**に変換します。

💡 リクエスト例：

```
const response = await fetch('/api/user/aff_transfer', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    quota: 50000  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "划转成功"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "邀请额度不足！"  
}
```

🧾 フィールドの説明：

`quota` （数値）: 変換する**額度**数量。最小単位**額度**以上である必要があります

#### ユーザー設定の更新

- **インターフェース名**：ユーザー設定の更新
- **HTTP メソッド**：PUT
- **パス**：`/api/user/setting`
- **認証要件**：ユーザー
- **機能概要**：ユーザーの個人設定構成を更新します。

💡 リクエスト例：

```
const response = await fetch('/api/user/setting', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_user_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    theme: "dark",  
    language: "zh-CN",  
    notifications: {  
      email: true,  
      browser: false  
    }  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "设置更新成功"  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "设置格式错误"  
}
```

🧾 フィールドの説明：

- リクエストボディには任意のユーザー設定フィールドを含めることができ、JSON 形式で送信されます
- 具体的なフィールドは、フロントエンドの設定ページの要件によって異なります

## 管理者によるユーザー管理

### 🔐 管理者認証

#### すべてのユーザーリストの取得

- **インターフェース名**：すべてのユーザーリストの取得
- **HTTP メソッド**：GET
- **パス**：`/api/user/`
- **認証要件**：管理者
- **機能概要**：システム内のすべてのユーザーのリスト情報をページングして取得します。

💡 リクエスト例：

```
const response = await fetch('/api/user/?p=1&page_size=20', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "username": "testuser",  
        "display_name": "Test User",  
        "role": 1,  
        "status": 1,  
        "email": "user@example.com",  
        "group": "default",  
        "quota": 1000000,  
        "used_quota": 50000,  
        "request_count": 100  
      }  
    ],  
    "total": 50,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "获取用户列表失败"  
}
```

🧾 フィールドの説明：

- `p` （数値）: ページ番号。デフォルトは 1
- `page_size` （数値）: ページあたりの数量。デフォルトは 20
- `items` （配列）: ユーザー情報リスト
- `total` （数値）: ユーザー総数
- `page` （数値）: 現在のページ番号
- `page_size` （数値）: ページあたりの数量

#### ユーザーの検索

- **インターフェース名**：ユーザーの検索
- **HTTP メソッド**：GET
- **パス**：`/api/user/search`
- **認証要件**：管理者
- **機能概要**：キーワードと**グループ**に基づいてユーザーを検索します。

💡 リクエスト例：

```
const response = await fetch('/api/user/search?keyword=test&group=default&p=1&page_size=20', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "items": [  
      {  
        "id": 1,  
        "username": "testuser",  
        "display_name": "Test User",  
        "role": 1,  
        "status": 1,  
        "email": "test@example.com",  
        "group": "default"  
      }  
    ],  
    "total": 1,  
    "page": 1,  
    "page_size": 20  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "搜索用户失败"  
}
```

🧾 フィールドの説明：

- `keyword` （文字列）: 検索キーワード。ユーザー名、表示名、メールアドレスに一致します
- `group` （文字列）: ユーザー**グループ**のフィルタリング条件
- `p` （数値）: ページ番号。デフォルトは 1
- `page_size` （数値）: ページあたりの数量。デフォルトは 20

#### 個別ユーザー情報の取得

- **インターフェース名**：個別ユーザー情報の取得
- **HTTP メソッド**：GET
- **パス**：`/api/user/:id`
- **認証要件**：管理者
- **機能概要**：指定されたユーザーの詳細情報（権限チェックを含む）を取得します。

💡 リクエスト例：

```
const response = await fetch('/api/user/123', {  
  method: 'GET',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": "",  
  "data": {  
    "id": 123,  
    "username": "targetuser",  
    "display_name": "Target User",  
    "role": 1,  
    "status": 1,  
    "email": "target@example.com",  
    "group": "default",  
    "quota": 1000000,  
    "used_quota": 50000,  
    "request_count": 100,  
    "aff_code": "ABC123",  
    "aff_count": 5  
  }  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "无权获取同级或更高等级用户的信息"  
}
```

🧾 フィールドの説明：

- `id` （数値）: ユーザー ID。URL パスを通じて渡されます
- 完全なユーザー情報が返されますが、管理者は同等またはそれ以上の権限を持つユーザーの情報を表示できません

#### ユーザーの作成

- **インターフェース名**：ユーザーの作成
- **HTTP メソッド**：POST
- **パス**：`/api/user/`
- **認証要件**：管理者
- **機能概要**：新規ユーザーアカウントを作成します。管理者は自分以上の権限を持つユーザーを作成できません。

💡 リクエスト例：

```
const response = await fetch('/api/user/', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id' 
  },  
  body: JSON.stringify({  
    username: "newuser",  
    password: "password123",  
    display_name: "New User",  
    role: 1  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "无法创建权限大于等于自己的用户"  
}
```

🧾 フィールドの説明：

- `username` （文字列）: ユーザー名。必須
- `password` （文字列）: パスワード。必須
- `display_name` （文字列）: 表示名。オプション。デフォルトはユーザー名
- `role` （数値）: ユーザーロール。現在の管理者ロールよりも小さい必要があります

#### 凍結/リセットなどの管理操作

- **インターフェース名**：凍結/リセットなどの管理操作
- **HTTP メソッド**：POST
- **パス**：`/api/user/manage`
- **認証要件**：管理者
- **機能概要**：ユーザーに対して管理操作（有効化、無効化、削除、昇格、降格など）を実行します。

💡 リクエスト例：

```
const response = await fetch('/api/user/manage', {  
  method: 'POST',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    id: 123,  
    action: "disable"  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "无法禁用超级管理员用户"  
}
```

🧾 フィールドの説明：

- `id` （数値）: ターゲットユーザー ID。必須
- `action` （文字列）: 操作タイプ。必須。選択可能な値：
    - `disable`： ユーザーを無効にする
    - `enable`： ユーザーを有効にする
    - `delete`： ユーザーを削除する
    - `promote`： 管理者に昇格させる（Root ユーザーのみ操作可能）
    - `demote`： 一般ユーザーに降格させる

#### ユーザーの更新

- **インターフェース名**：ユーザーの更新
- **HTTP メソッド**：PUT
- **パス**：`/api/user/`
- **認証要件**：管理者
- **機能概要**：ユーザー情報を更新します。権限チェックと**クォータ**変更の記録が含まれます。

💡 リクエスト例：

```
const response = await fetch('/api/user/', {  
  method: 'PUT',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  },  
  body: JSON.stringify({  
    id: 123,  
    username: "updateduser",  
    display_name: "Updated User",  
    email: "updated@example.com",  
    quota: 2000000,  
    role: 1,  
    status: 1  
  })  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "无权更新同权限等级或更高权限等级的用户信息"  
}
```

🧾 フィールドの説明：

- `id` （数値）: ユーザー ID。必須
- `username` （文字列）: ユーザー名。オプション
- `display_name` （文字列）: 表示名。オプション
- `email` （文字列）: メールアドレス。オプション
- `password` （文字列）: 新しいパスワード。オプション。空の場合はパスワードを更新しません
- `quota` （数値）: ユーザー**クォータ**。オプション
- `role` （数値）: ユーザーロール。現在の管理者ロール以上であってはなりません
- `status` （数値）: ユーザーの状態。オプション

#### ユーザーの削除

- **インターフェース名**：ユーザーの削除
- **HTTP メソッド**：DELETE
- **パス**：`/api/user/:id`
- **認証要件**：管理者
- **機能概要**：指定されたユーザーを物理的に削除します。管理者は同等またはそれ以上の権限を持つユーザーを削除できません。

💡 リクエスト例：

```
const response = await fetch('/api/user/123', {  
  method: 'DELETE',  
  headers: {  
    'Content-Type': 'application/json',  
    'Authorization': 'Bearer your_admin_token',
    'New-Api-User': 'your_user_id'
  }  
});  
const data = await response.json();
```

✅ 成功レスポンス例：

```
{  
  "success": true,  
  "message": ""  
}
```

❗ 失敗レスポンス例：

```
{  
  "success": false,  
  "message": "无权删除同权限等级或更高权限等级的用户"  
}
```

🧾 フィールドの説明：

- `id` （数値）: ユーザー ID。URL パスを通じて渡されます
- 物理的な削除操作を実行します。回復不能です