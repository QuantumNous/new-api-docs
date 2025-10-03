## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響します | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス割り当て量 | Available service quota for users |

# チャネル

ここで NewAPI のアップストリームチャネルを管理できます

![チャネル](../../assets/guide/channel.png)

## チャネル作成/編集ページ
![チャネル管理1](../../assets/guide/create-channel-1.png)

![チャネル管理2](../../assets/guide/create-channel-2.png)

![チャネル管理3](../../assets/guide/create-channel-3.png)

# パラメータ上書き設定ドキュメント

## 概要

パラメータ上書きシステムは、2つのモードをサポートしています：シンプル上書きモード（前方互換性）と高度な操作モードです。柔軟な条件判定と操作タイプにより、複雑なパラメータの動的な調整を実現できます。

## 使用方法

### シンプル上書きモード

前方互換性のため、上書きするフィールドと値を直接指定すると、システムはこれらのフィールドを元のリクエストにマージします。

```json
{
  "temperature": 0.8,
  "max_tokens": 2000,
  "model": "gpt-4"
}
```

### 高度な操作モード

`operations` 配列を通じて複雑なパラメータ操作を定義し、条件判定、配列操作、文字列連結などの高度な機能をサポートします。

#### 基本構造

```json
{
  "operations": [
    {
      "path": "temperature",
      "mode": "set",
      "value": 0.8,
      "conditions": [...],
      "logic": "AND"
    }
  ]
}
```

## 操作モード (mode)

### 1. set - 値の設定
指定されたパスの値を設定します

```json
{
  "path": "temperature",
  "mode": "set",
  "value": 0.8,
  "keep_origin": false
}
```

**パラメータ説明：**
- `keep_origin`: `true` の場合、ターゲットパスに既に値が存在していれば設定をスキップします

### 2. delete - フィールドの削除
指定されたパスのフィールドを削除します

```json
{
  "path": "messages.0",
  "mode": "delete"
}
```

### 3. move - フィールドの移動
あるフィールドの値を別の位置に移動します

```json
{
  "mode": "move",
  "from": "messages.0.content",
  "to": "system"
}
```

### 4. append - 内容の追加
既存の内容の後に新しい内容を追加します

```json
{
  "path": "messages.0.content",
  "mode": "append",
  "value": "\n\n请用中文回答。"
}
```

**サポートされるデータ型：**
- **文字列**: 元の文字列の末尾に追加
- **配列**: 配列の末尾に要素を追加（単一要素または配列の追加をサポート）
- **オブジェクト**: オブジェクト属性をマージ

### 5. prepend - 内容の前に挿入
既存の内容の前に新しい内容を追加します

```json
{
  "path": "messages.0.content",
  "mode": "prepend",
  "value": "重要提示：请仔细阅读以下内容。\n\n"
}
```

**サポートされるデータ型：**
- **文字列**: 元の文字列の先頭に挿入
- **配列**: 配列の先頭に要素を追加（単一要素または配列の追加をサポート）
- **オブジェクト**: オブジェクト属性をマージ

## 条件判定

`conditions` 配列を通じて操作実行の条件を設定します。条件を満たした場合にのみ操作が実行されます。

### 条件構造

```json
{
  "conditions": [
    {
      "path": "model",
      "mode": "contains",
      "value": "gpt-4",
      "invert": false,
      "pass_missing_key": false
    }
  ],
  "logic": "AND"
}
```

### 条件マッチングモード

- `full`: 完全一致（デフォルト）
- `prefix`: 前方一致
- `suffix`: 後方一致
- `contains`: 部分一致（含む）
- `gt`: より大きい（数値型のみ）
- `gte`: 以上（数値型のみ）
- `lt`: より小さい（数値型のみ）
- `lte`: 以下（数値型のみ）


- 注意：
* 数値比較は数値型にのみ使用できます
* 文字列操作（prefix、suffix、contains）は値を文字列に変換して比較を行います

### 条件パラメータ説明

- `invert`: 反転機能、`true` は結果を反転することを意味します
- `pass_missing_key`: 指定されたパスが存在しない場合の動作
  - `true`: パスが存在しない場合、条件は通過します
  - `false`: パスが存在しない場合、条件は通過しません（デフォルト）

### 論理関係 (logic)

- `AND`: すべての条件を満たす必要があります
- `OR`: いずれかの条件を満たせば実行されます（デフォルト）

## パス構文

JSONパス構文を使用してネストされたフィールドにアクセスします：

- `temperature` - ルートレベルのフィールド
- `messages.0.content` - 配列の最初の要素の content フィールド
- `messages.-1.content` - 配列の最後の要素の content フィールド
- `metadata.user.name` - ネストされたオブジェクトフィールド

## 実用的な例

### 1. モデルパラメータの動的調整

メッセージ内容に基づいて温度パラメータを動的に調整します：

```json
{
  "operations": [
    {
      "path": "temperature",
      "mode": "set",
      "value": 0.3,
      "conditions": [
        {
          "path": "messages.0.content",
          "mode": "contains",
          "value": "代码"
        }
      ]
    },
    {
      "path": "temperature",
      "mode": "set",
      "value": 0.9,
      "conditions": [
        {
          "path": "messages.0.content",
          "mode": "contains",
          "value": "创意"
        }
      ]
    }
  ]
}
```

### 2. システムプロンプトの追加

メッセージ配列の先頭にシステムメッセージを追加します：

```json
{
  "operations": [
    {
      "path": "messages",
      "mode": "prepend",
      "value": [
        {
          "role": "system",
          "content": "你是一个专业的AI助手，请始终保持礼貌和专业。"
        }
      ]
    }
  ]
}
```

### 3. モデルタイプに基づくパラメータ調整

異なるモデルに基づいて異なる `max_tokens` を設定します：

```json
{
  "operations": [
    {
      "path": "max_tokens",
      "mode": "set",
      "value": 4000,
      "conditions": [
        {
          "path": "model",
          "mode": "prefix",
          "value": "gpt-4"
        }
      ]
    },
    {
      "path": "max_tokens",
      "mode": "set",
      "value": 2000,
      "conditions": [
        {
          "path": "model",
          "mode": "prefix",
          "value": "gpt-3.5"
        }
      ]
    }
  ]
}
```

### 4. 複数条件の組み合わせ（ANDロジック）

複数の条件を同時に満たした場合にのみ操作を実行します：

```json
{
  "operations": [
    {
      "path": "stream",
      "mode": "set",
      "value": false,
      "conditions": [
        {
          "path": "model",
          "mode": "contains",
          "value": "claude"
        },
        {
          "path": "messages.0.content",
          "mode": "contains",
          "value": "长文"
        }
      ],
      "logic": "AND"
    }
  ]
}
```

### 5. 数値比較条件

数値の大小に基づいて条件判定を行います：

```json
{
  "operations": [
    {
      "path": "temperature",
      "mode": "set",
      "value": 0.1,
      "conditions": [
        {
          "path": "max_tokens",
          "mode": "gt",
          "value": 1000
        }
      ]
    }
  ]
}
```

### 6. 反転条件

`invert` を使用して反転ロジックを実現します：

```json
{
  "operations": [
    {
      "path": "stream",
      "mode": "set",
      "value": true,
      "conditions": [
        {
          "path": "model",
          "mode": "contains",
          "value": "gpt-3.5",
          "invert": true
        }
      ]
    }
  ]
}
```

### 7. 欠落フィールドの処理

`pass_missing_key` を使用して、存在しない可能性のあるフィールドを処理します：

```json
{
  "operations": [
    {
      "path": "temperature",
      "mode": "set",
      "value": 0.7,
      "conditions": [
        {
          "path": "custom_field",
          "mode": "full",
          "value": "special",
          "pass_missing_key": true
        }
      ]
    }
  ]
}
```

### 8. 文字列連結の例

ユーザーメッセージの後に指示文を追加します：

```json
{
  "operations": [
    {
      "path": "messages.-1.content",
      "mode": "append",
      "value": "\n\n请详细解释你的思考过程。"
    }
  ]
}
```

## 注意事項

**実行順序**: 操作は `operations` 配列内の順序に従って順番に実行され、前の操作が後続の操作に影響を与えます