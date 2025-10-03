## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響する | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# 支払い設定

ここでは、チャージ機能に関連する設定を構成できます。

![支付设置](../../../assets/guide/payment-setting.png)

![Stripe](../../../assets/guide/stripe.png)

## 対応する決済ゲートウェイ

- **易支付（EPay）**
  - 必須項目：`API アドレス`、`マーチャント ID（PID）`、`マーチャントキー（KEY）`
  - プラットフォームのコールバックパラメーターには署名が含まれており、システムが検証し、自動的に入金処理を行います。
- **Stripe（オプション）**
  - 必須項目：`API キー` `WebHook 署名キー` `商品価格 ID`

## EPay（易支付）とは

`易支付`は、「サードパーティの集約型決済ゲートウェイ/インターフェース」モデルの総称であり、特定のウェブサイトや企業を指すものではありません。商用の集約決済サービスを指す場合もあれば、自社構築/オープンソースで「易支付プロトコルスタイル」に準拠したゲートウェイ実装を指す場合もあります。

- **核となる役割**: WeChat Pay、Alipay、銀行カードなどのチャネルを集約し、マーチャントに統一された注文、署名検証、およびコールバックインターフェースを提供します。
- **コンプライアンスに関する注意**: ゲートウェイ自体は、ライセンスを持つ決済機関と同等ではありません。資金の清算・決済およびコンプライアンスは、接続先のライセンスを持つチャネルに依存します。所在地の規制およびリスク管理要件に従ってください。

## チャージ方法設定テンプレート

「チャージ方法」では、以下の構造で設定できます。

```json
[
  {
    "color": "rgba(var(--semi-blue-5), 1)",
    "name": "支付宝",
    "type": "alipay"
  },
  {
    "color": "rgba(var(--semi-green-5), 1)",
    "name": "微信",
    "type": "wxpay"
  },
  {
    "color": "rgba(var(--semi-green-5), 1)",
    "name": "Stripe",
    "type": "stripe",
    "min_topup": "50"
  },
  {
    "name":      "自定义1",
    "color":     "black",
    "type":      "custom1",
    "min_topup": "50"
   }
]
```

### フィールドの説明

- name: 表示テキスト。「支払い方法の選択」ボタンに表示されます（例：「Alipay/WeChat/Stripe/カスタム1」）。
- color: ボタン/バッジのテーマカラーまたはボーダーカラー。任意の CSS カラー値をサポートしますが、既存のデザイン・トークン（例： `rgba(var(--semi-blue-5), 1)`）の使用を推奨します。
- type: チャネル識別子。バックエンドのルーティングと注文に使用されます。
  - `stripe` → Stripe ゲートウェイを経由します。
  - その他（例： `alipay`、`wxpay`、`custom1` など）→ 易支付スタイルのゲートウェイを経由し、この値がチャネルパラメーターとして透過的に渡されます。
  - 詳細なロジックはバックエンドコントローラー `controller/topup.go` を参照してください（参照: [controller/topup.go](https://github.com/QuantumNous/new-api/blob/main/controller/topup.go)）。
- min_topup: 最低チャージ金額（単位はページ上の通貨と一致）。入力された金額がこの値より少ない場合、ページに「この支払い方法の最低チャージ金額は X です」と表示され、支払い開始が制限されます。バックエンドでも検証が行われます。
- ソート順: 配列の順序に従って左から右にレンダリングされます。

## チャージ金額設定

### カスタムチャージ数量オプション

ユーザーが選択できるチャージ数量オプションを設定します。例：

```json
[10, 20, 50, 100, 200, 500]
```

これらの数値は「チャージ枠の選択」エリアに表示され、ユーザーはクリックして対応するチャージ金額を直接選択できます。

### チャージ金額割引設定

異なるチャージ金額に対応する割引を設定します。キーはチャージ金額、値は割引率です。例：

```json
{
  "100": 0.95,
  "200": 0.9,
  "500": 0.85
}
```

- キー：チャージ金額（文字列形式）
- 値：割引率（0～1の間の小数。例：0.95 は価格の 95% を意味し、5% 割引となります）
- システムは設定に基づいて、実際の支払い金額と節約金額を自動的に計算します
- 詳細な実装ロジックはバックエンドコントローラー [controller/topup.go](https://github.com/QuantumNous/new-api/blob/main/controller/topup.go) を参照してください