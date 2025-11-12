# OpenAI 画像フォーマット（Image）

!!! info "公式ドキュメント"
    [OpenAI Images](https://platform.openai.com/docs/api-reference/images)

## 📝 概要

テキストプロンプトおよび/または入力画像に基づいて、モデルは新しい画像を生成します。OpenAIは、自然言語の記述に基づいて画像を生成、編集、修正できる、複数の強力な画像生成モデルを提供しています。現在サポートされているモデルは以下の通りです：

| モデル | 説明 |
| --- | --- |
| **DALL·E シリーズ** | DALL·E 2とDALL·E 3の2つのバージョンがあり、画質、創造性、精度において大きな違いがあります |
| **GPT-Image-1** | OpenAIの最新画像モデルで、複数画像編集機能をサポートしており、複数の入力画像に基づいて新しい合成画像を作成できます |

## 💡 リクエスト例

### 画像の生成 ✅

```bash
# 基础图片生成
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

**応答例:**

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

**応答例 (dall-e-2):**

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

**応答例 (gpt-image-1):**

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

**応答例:**

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

#### 画像の生成
```
POST /v1/images/generations
```

テキストプロンプトに基づいて画像を生成します。

#### 画像の編集
```
POST /v1/images/edits
```

1つまたは複数のオリジナル画像とプロンプトに基づいて、編集または拡張された画像を生成します。このエンドポイントは dall-e-2 および gpt-image-1 モデルをサポートしています。

#### バリエーションの生成
```
POST /v1/images/variations
```

指定された画像のバリエーションを作成します。

### 認証方法

リクエストヘッダーに以下を含めてAPIキー認証を行います：

```
Authorization: Bearer $NEWAPI_API_KEY
```

ここで `$OPENAI_API_KEY` はお客様の API キーです。

### リクエストボディパラメータ

#### 画像の生成

##### `prompt`
- 型：文字列
- 必須：はい
- 説明：生成を希望する画像のテキスト記述。
  - dall-e-2 の最大長は 1000 文字
  - dall-e-3 の最大長は 4000 文字
- ヒント：
  - 具体かつ詳細な記述を使用する
  - 重要な視覚的要素を含める
  - 希望するアートスタイルを指定する
  - 構図と視点を記述する

##### `model`
- 型：文字列
- 必須：いいえ
- デフォルト値：dall-e-2
- 説明：画像生成に使用するモデル。

##### `n`
- 型：整数または null
- 必須：いいえ
- デフォルト値：1
- 説明：生成する画像の数。1から10の間である必要があります。dall-e-3 は n=1 のみサポートしています。

##### `quality`
- 型：文字列
- 必須：いいえ
- デフォルト値：standard
- 説明：生成される画像の品質。hd オプションは、より詳細で一貫性のある画像を生成します。このパラメータは dall-e-3 のみサポートしています。

##### `response_format`
- 型：文字列または null
- 必須：いいえ
- デフォルト値：url
- 説明：生成された画像が返される形式。url または b64_json のいずれかである必要があります。URL は生成後 60 分間有効です。

##### `size`
- 型：文字列または null
- 必須：いいえ
- デフォルト値：1024x1024
- 説明：生成される画像のサイズ。dall-e-2 の場合、256x256、512x512、または 1024x1024 のいずれかである必要があります。dall-e-3 の場合、1024x1024、1792x1024、または 1024x1792 のいずれかである必要があります。

##### `style`
- 型：文字列または null
- 必須：いいえ
- デフォルト値：vivid
- 説明：生成される画像のスタイル。vivid または natural のいずれかである必要があります。vivid は超現実的で劇的な画像を生成する傾向があり、natural はより自然で超現実的ではない画像を生成する傾向があります。このパラメータは dall-e-3 のみサポートしています。

##### `user`
- 型：文字列
- 必須：いいえ
- 説明：エンドユーザーを表す一意の識別子。OpenAIが不正行為を監視および検出するのに役立ちます。

#### 画像の編集

##### `image`
- 型：ファイルまたはファイル配列
- 必須：はい
- 説明：編集する画像。
  - dall-e-2 の場合：有効な PNG ファイルであり、4MB未満、かつ正方形である必要があります。マスクが提供されていない場合、画像は透明度を持っている必要があり、それがマスクとして使用されます。
  - gpt-image-1 の場合：複数の画像を配列として提供でき、各画像はPNG、WEBP、またはJPGファイルで、25MB未満である必要があります。

##### `prompt`
- 型：文字列
- 必須：はい
- 説明：生成を希望する画像のテキスト記述。
  - dall-e-2 の最大長は 1000 文字
  - gpt-image-1 の最大長は 32000 文字

##### `mask`
- 型：ファイル
- 必須：いいえ
- 説明：完全に透明な領域（アルファ値がゼロの領域など）が編集すべき位置を示す追加の画像。複数の画像が提供された場合、マスクは最初の画像に適用されます。有効なPNGファイルであり、4MB未満、かつ image と同じサイズである必要があります。

##### `model`
- 型：文字列
- 必須：いいえ
- デフォルト値：dall-e-2
- 説明：画像生成に使用するモデル。dall-e-2 および gpt-image-1 をサポートします。gpt-image-1 固有のパラメータが使用されていない限り、デフォルトは dall-e-2 です。

##### `quality`
- 型：文字列または null
- 必須：いいえ
- デフォルト値：auto
- 説明：生成される画像の品質。
  - gpt-image-1 は high、medium、low をサポート
  - dall-e-2 は standard のみサポート
  - デフォルトは auto

##### `size`
- 型：文字列または null
- 必須：いいえ
- デフォルト値：1024x1024
- 説明：生成される画像のサイズ。
  - gpt-image-1 の場合、1024x1024、1536x1024（横長）、1024x1536（縦長）、または auto（デフォルト）のいずれかである必要があります。
  - dall-e-2 の場合、256x256、512x512、または 1024x1024 のいずれかである必要があります。

その他のパラメータは、画像生成インターフェースと同じです。

#### バリエーションの生成

##### `image`
- 型：ファイル
- 必須：はい
- 説明：バリエーションの基となる画像。有効な PNG ファイルであり、4MB未満、かつ正方形である必要があります。

その他のパラメータは、画像生成インターフェースと同じです。

## 📥 応答

### 成功応答

これら3つのエンドポイントはすべて、画像オブジェクトのリストを含む応答を返します。

#### `created`
- 型：整数
- 説明：応答が作成されたタイムスタンプ

#### `data`
- 型：配列
- 説明：生成された画像オブジェクトのリスト

#### `usage`（gpt-image-1 のみ適用）
- 型：オブジェクト
- 説明：API呼び出しのトークン使用状況
  - `total_tokens`：使用された合計トークン数
  - `input_tokens`：入力に使用されたトークン数
  - `output_tokens`：出力に使用されたトークン数
  - `input_tokens_details`：入力トークンの詳細（テキストトークンと画像トークン）

### 画像オブジェクト

#### `b64_json`
- 型：文字列
- 説明：`response_format` が b64_json の場合、生成された画像の base64 エンコードされたJSONが含まれます

#### `url`
- 型：文字列
- 説明：`response_format` が url（デフォルト）の場合、生成された画像のURLが含まれます

#### `revised_prompt`
- 型：文字列
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
3. 希望するアートスタイルと雰囲気を記述する
4. 構図と視点の説明に注意する

### パラメータ選択の推奨事項

1. モデル選択
   - dall-e-3：高品質で正確な詳細が必要なシナリオに適しています
   - dall-e-2：迅速なプロトタイプ作成やシンプルな画像生成に適しています

2. サイズ選択
   - 1024x1024：一般的なシナリオに最適な選択
   - 1792x1024/1024x1792：横長/縦長のシナリオに適しています
   - 小さいサイズ：サムネイルやクイックプレビューに適しています

3. 品質とスタイル
   - quality=hd：精細な詳細が必要な画像に使用
   - style=vivid：創造的で芸術的な効果に適しています
   - style=natural：現実のシーンの再現に適しています

### よくある質問

1. 画像生成の失敗
   - プロンプトがコンテンツポリシーに準拠しているか確認する
   - ファイル形式とサイズ制限を確認する
   - APIキーの権限を検証する

2. 結果が期待と一致しない
   - プロンプトの記述を最適化する
   - 品質とスタイルのパラメータを調整する
   - 画像編集またはバリエーション機能の使用を検討する