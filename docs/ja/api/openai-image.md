# OpenAI 画像フォーマット（Image）

!!! info "公式ドキュメント"
    [OpenAI Images](https://platform.openai.com/docs/api-reference/images)

## 📝 概要

テキストプロンプトおよび/または入力画像が与えられると、モデルは新しい画像を生成します。OpenAIは、自然言語の記述に基づいて画像を生成、編集、修正できる、複数の強力な画像生成モデルを提供しています。現在サポートされているモデルは以下の通りです。

| モデル | 説明 |
| --- | --- |
| **DALL·E シリーズ** | DALL·E 2とDALL·E 3の2つのバージョンを含み、画質、創造性、精度において大きな違いがあります |
| **GPT-Image-1** | OpenAIの最新画像モデルで、複数画像編集機能をサポートしており、複数の入力画像に基づいて新しい合成画像を作成できます |

## 💡 リクエスト例

### 画像の作成 ✅

```bash
# 基礎图片生成
curl https://你的newapi服务器地址/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的小海獭",
    "n": 1,
    "size": "1024x1024"
  }'

# 高质量图片生成
curl https://你的newapi服务器地址/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的小海獭",
    "quality": "hd",
    "style": "vivid",
    "size": "1024x1024"
  }'

# 使用 base64 返回格式
curl https://你的newapi服务器地址/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的小海獭",
    "response_format": "b64_json"
  }'
```

**レスポンス例:**

```json
{
  "created": 1589478378,
  "data": [
    {
      "url": "https://...",
      "revised_prompt": "一只可爱的小海獭在水中嬉戏,它有着圆圆的眼睛和毛茸茸的皮毛"
    }
  ]
}
```

### 画像の編集 ✅

```bash
# dall-e-2 图片编辑
curl https://你的newapi服务器地址/v1/images/edits \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F image="@otter.png" \
  -F mask="@mask.png" \
  -F prompt="一只戴着贝雷帽的可爱小海獭" \
  -F n=2 \
  -F size="1024x1024"

# gpt-image-1 多图片编辑示例
curl https://你的newapi服务器地址/v1/images/edits \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F "model=gpt-image-1" \
  -F "image[]=@body-lotion.png" \
  -F "image[]=@bath-bomb.png" \
  -F "image[]=@incense-kit.png" \
  -F "image[]=@soap.png" \
  -F "prompt=创建一个包含这四个物品的精美礼品篮" \
  -F "quality=high"
```

**レスポンス例 (dall-e-2):**

```json
{
  "created": 1589478378,
  "data": [
    {
      "url": "https://..."
    },
    {
      "url": "https://..."
    }
  ]
}
```

**レスポンス例 (gpt-image-1):**

```json
{
  "created": 1713833628,
  "data": [
    {
      "b64_json": "..."
    }
  ],
  "usage": {
    "total_tokens": 100,
    "input_tokens": 50,
    "output_tokens": 50,
    "input_tokens_details": {
      "text_tokens": 10,
      "image_tokens": 40
    }
  }
}
```

### 画像バリエーションの生成 ✅

```bash
curl https://你的newapi服务器地址/v1/images/variations \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -F image="@otter.png" \
  -F n=2 \
  -F size="1024x1024"
```

**レスポンス例:**

```json
{
  "created": 1589478378,
  "data": [
    {
      "url": "https://..."
    },
    {
      "url": "https://..."
    }
  ]
}
```

## 📮 リクエスト

### エンドポイント

#### 画像の作成
```
POST /v1/images/generations
```

テキストプロンプトに基づいて画像を生成します。

#### 画像の編集
```
POST /v1/images/edits
```

1つまたは複数のオリジナル画像とプロンプトに基づいて、編集または拡張された画像を生成します。このエンドポイントは、dall-e-2 および gpt-image-1 モデルをサポートしています。

#### バリエーションの生成
```
POST /v1/images/variations
```

指定された画像のバリエーションを作成します。

### 認証方法

APIキー認証を行うには、リクエストヘッダーに以下を含めます。

```
Authorization: Bearer $NEWAPI_API_KEY
```

ここで `$OPENAI_API_KEY` はあなたの API キーです。

### リクエストボディパラメータ

#### 画像の作成

##### `prompt`
- タイプ：文字列 (string)
- 必須：はい
- 説明：生成を希望する画像のテキスト記述（プロンプト）。
  - dall-e-2 の最大長は 1000 文字
  - dall-e-3 の最大長は 4000 文字
- ヒント：
  - 具体的かつ詳細な記述を使用する
  - 重要な視覚的要素を含める
  - 希望するアートスタイルを指定する
  - 構図と視点を記述する

##### `model`
- タイプ：文字列 (string)
- 必須：いいえ
- デフォルト値：dall-e-2
- 説明：画像生成に使用するモデル。

##### `n`
- タイプ：整数 (integer) または null
- 必須：いいえ
- デフォルト値：1
- 説明：生成する画像の数。1〜10の間である必要があります。dall-e-3 は n=1 のみをサポートしています。

##### `quality`
- タイプ：文字列 (string)
- 必須：いいえ
- デフォルト値：standard
- 説明：生成される画像の品質。hd オプションは、より詳細で一貫性のある画像を生成します。dall-e-3 のみがこのパラメータをサポートしています。

##### `response_format`
- タイプ：文字列 (string) または null
- 必須：いいえ
- デフォルト値：url
- 説明：生成された画像を返す形式。url または b64_json のいずれかである必要があります。URLは生成後60分間有効です。

##### `size`
- タイプ：文字列 (string) または null
- 必須：いいえ
- デフォルト値：1024x1024
- 説明：生成される画像のサイズ。dall-e-2 は 256x256、512x512、または 1024x1024 のいずれかである必要があります。dall-e-3 は 1024x1024、1792x1024、または 1024x1792 のいずれかである必要があります。

##### `style`
- タイプ：文字列 (string) または null
- 必須：いいえ
- デフォルト値：vivid
- 説明：生成される画像のスタイル。vivid または natural のいずれかである必要があります。vivid は超現実的で劇的な画像を生成する傾向があり、natural はより自然で非現実的ではない画像を生成する傾向があります。dall-e-3 のみがこのパラメータをサポートしています。

##### `user`
- タイプ：文字列 (string)
- 必須：いいえ
- 説明：エンドユーザーを表す一意の識別子。OpenAIが不正行為を監視および検出するのに役立ちます。

#### `moderation`
- タイプ：文字列 (string)
- 必須：いいえ
- デフォルト値：auto
- 説明：auto：標準的なモデレーション。年齢に不適切な可能性のある特定の内容カテゴリの生成を制限することを目的としています。low：制限の少ないモデレーション。

#### 画像の編集

##### `image`
- タイプ：ファイルまたはファイル配列
- 必須：はい
- 説明：編集する画像。
  - dall-e-2 の場合：有効な PNG ファイルであり、4MB未満、かつ正方形である必要があります。mask が提供されない場合、画像は透明度を持っている必要があり、それがマスクとして使用されます。
  - gpt-image-1 の場合：配列として複数の画像を提供できます。各画像は PNG、WEBP、または JPG ファイルで、25MB未満である必要があります。

##### `prompt`
- タイプ：文字列 (string)
- 必須：はい
- 説明：生成を希望する画像のテキスト記述（プロンプト）。
  - dall-e-2 の最大長は 1000 文字
  - gpt-image-1 の最大長は 32000 文字

##### `mask`
- タイプ：ファイル
- 必須：いいえ
- 説明：追加の画像。完全に透明な領域（アルファがゼロの領域など）が、編集すべき位置を示します。複数の画像が提供された場合、mask は最初の画像に適用されます。有効な PNG ファイルであり、4MB未満、かつ image と同じサイズである必要があります。

##### `model`
- タイプ：文字列 (string)
- 必須：いいえ
- デフォルト値：dall-e-2
- 説明：画像生成に使用するモデル。dall-e-2 および gpt-image-1 をサポートしています。gpt-image-1 固有のパラメータが使用されていない限り、デフォルトは dall-e-2 です。

##### `quality`
- タイプ：文字列 (string) または null
- 必須：いいえ
- デフォルト値：auto
- 説明：生成される画像の品質。
  - gpt-image-1 は high、medium、low をサポート
  - dall-e-2 は standard のみをサポート
  - デフォルトは auto

##### `size`
- タイプ：文字列 (string) または null
- 必須：いいえ
- デフォルト値：1024x1024
- 説明：生成される画像のサイズ。
  - gpt-image-1 は 1024x1024、1536x1024（横長）、1024x1536（縦長）、または auto（デフォルト）のいずれかである必要があります。
  - dall-e-2 は 256x256、512x512、または 1024x1024 のいずれかである必要があります。

その他のパラメータは、画像作成インターフェースと同じです。

#### バリエーションの生成

##### `image`
- タイプ：ファイル
- 必須：はい
- 説明：バリエーションの基となる画像。有効な PNG ファイルであり、4MB未満、かつ正方形である必要があります。

その他のパラメータは、画像作成インターフェースと同じです。

## 📥 レスポンス

### 成功レスポンス

3つのエンドポイントすべてが、画像オブジェクトのリストを含むレスポンスを返します。

#### `created`
- タイプ：整数 (integer)
- 説明：レスポンスが作成されたタイムスタンプ

#### `data`
- タイプ：配列 (array)
- 説明：生成された画像オブジェクトのリスト

#### `usage`（gpt-image-1にのみ適用）
- タイプ：オブジェクト (object)
- 説明：API呼び出しのトークン使用状況
  - `total_tokens`：使用された合計トークン数
  - `input_tokens`：入力に使用されたトークン数
  - `output_tokens`：出力に使用されたトークン数
  - `input_tokens_details`：入力トークンの詳細情報（テキストトークンと画像トークン）

### 画像オブジェクト

#### `b64_json`
- タイプ：文字列 (string)
- 説明：response_format が b64_json の場合、生成された画像の base64 エンコードされたJSONが含まれます

#### `url`
- タイプ：文字列 (string)
- 説明：response_format が url（デフォルト）の場合、生成された画像のURLが含まれます

#### `revised_prompt`
- タイプ：文字列 (string)
- 説明：プロンプトが修正された場合、画像生成に使用された修正後のプロンプトが含まれます

画像オブジェクトの例:
```json
{
  "url": "https://...",
  "revised_prompt": "一只可爱的小海獭在水中嬉戏,它有着圆圆的眼睛和毛茸茸的皮毛"
}
```

## 🌟 ベストプラクティス

### プロンプト作成の推奨事項

1. 明確で具体的な記述を使用する
2. 重要な視覚的詳細を指定する
3. 期待するアートスタイルと雰囲気を記述する
4. 構図と視点の説明に注意する

### パラメータ選択の推奨事項

1. モデルの選択
   - dall-e-3：高品質で正確な詳細が必要なシナリオに適しています
   - dall-e-2：迅速なプロトタイプ作成やシンプルな画像生成に適しています

2. サイズの選択
   - 1024x1024：一般的なシナリオでの最良の選択
   - 1792x1024/1024x1792：横長/縦長のシナリオに適しています
   - より小さいサイズ：サムネイルやクイックプレビューに適しています

3. 品質とスタイル
   - quality=hd：詳細なディテールが必要な画像に使用
   - style=vivid：創造的で芸術的な効果に適しています
   - style=natural：現実のシーンの再現に適しています

### よくある質問

1. 画像生成の失敗
   - プロンプトがコンテンツポリシーに準拠しているか確認してください
   - ファイル形式とサイズ制限を確認してください
   - APIキーの権限を検証してください

2. 結果が期待と一致しない
   - プロンプトの記述を最適化する
   - 品質とスタイルのパラメータを調整する
   - 画像編集またはバリエーション生成機能の使用を検討する