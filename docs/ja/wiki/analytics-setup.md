# 分析ツール設定ガイド

### 概要

New API は、ユーザー行動とウェブサイトのパフォーマンスを追跡するのに役立つ、一般的な分析プラットフォームとの統合をサポートしました。

- **Google Analytics 4 (GA4)**：Googleの分析プラットフォームの最新バージョン
- **Umami Analytics**：プライバシーを重視したオープンソースの分析ツール

両方の分析ツールを同時に有効にすることができ、互いに干渉しません。

### 機能の特徴

✅ コード不要の統合 - 環境変数のみで設定  
✅ Webインターフェースへのスクリプト自動注入  
✅ Dockerおよびスタンドアロンデプロイのサポート  
✅ プライバシーを重視した実装方法  
✅ フロントエンドコードの変更不要  

---

### Google Analytics 4 の設定

#### 1. 測定IDの取得

1. [Google Analytics](https://analytics.google.com/) にアクセス
2. 新しいプロパティを作成するか、既存のプロパティを選択
3. **管理** → **データストリーム** に移動
4. ウェブサイトのデータストリームを作成または選択
5. **測定ID** をコピーします（形式：`G-XXXXXXXXXX`）

#### 2. 環境変数の設定

**Docker Composeを使用する場合：**

`docker-compose.yml` ファイルを編集し、Google Analyticsの行のコメントを解除します：

```yaml
environment:
  - GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX  # 実際の測定IDに置き換えてください
```

**スタンドアロンデプロイの場合：**

`.env` ファイルに追加するか、環境変数として設定します：

```bash
export GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX
```

**Docker Runを使用する場合：**

```bash
docker run -d \
  -e GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX \
  ...其他选项...
  calciumion/new-api:latest
```

#### 3. アプリケーションの再起動

```bash
# Docker Compose
docker-compose down && docker-compose up -d

# 独立部署
# アプリケーションを直接再起動してください
```

---

### Umami Analytics の設定

#### 1. Umami認証情報の取得

**オプション A：Umami Cloudを使用**
1. [Umami Cloud](https://cloud.umami.is/) で登録
2. 新しいウェブサイトを追加
3. **ウェブサイトID** をコピーします（UUID形式）

**オプション B：Umamiをセルフホスティング**
1. 独自の [Umami インスタンス](https://umami.is/docs/install) をデプロイ
2. ダッシュボードでウェブサイトを作成
3. **ウェブサイトID** と **スクリプトURL** をコピー

#### 2. 環境変数の設定

**Docker Composeを使用する場合：**

`docker-compose.yml` ファイルを編集します：

```yaml
environment:
  - UMAMI_WEBSITE_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  # オプション：セルフホスティングインスタンスのみ必要
  - UMAMI_SCRIPT_URL=https://your-umami-domain.com/script.js
```

**スタンドアロンデプロイの場合：**

`.env` ファイルに追加します：

```bash
export UMAMI_WEBSITE_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
export UMAMI_SCRIPT_URL=https://your-umami-domain.com/script.js  # オプション
```

**注意：** Umami Cloudを使用する場合、デフォルトで公式URLが使用されるため、`UMAMI_SCRIPT_URL`を設定する必要はありません。

#### 3. アプリケーションの再起動

Google Analyticsと同様に、変更を適用するためにアプリケーションを再起動してください。

---

### 両方の分析ツールを同時に使用する

Google AnalyticsとUmamiを同時に有効にすることができます：

```yaml
environment:
  - GOOGLE_ANALYTICS_ID=G-ABC123XYZ
  - UMAMI_WEBSITE_ID=a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6
  - UMAMI_SCRIPT_URL=https://analytics.umami.is/script.js
```

---

### 検証

アプリケーションを再起動した後：

1. ブラウザでWebインターフェースを開く
2. ブラウザの開発者ツール（F12）を開き、**ネットワーク**タブに移動
3. ページを更新
4. 次の要求を探します：
   - Google Analytics：`https://www.googletagmanager.com/gtag/js`
   - Umami：設定したスクリプトURL

ページソースを表示し、`<head>`セクションに注入されたスクリプトを探すこともできます。

---

### トラブルシューティング

**分析ツールが機能しませんか？**

1. ✅ 環境変数が正しく設定されていることを確認
2. ✅ 変数変更後にアプリケーションを再起動
3. ✅ ブラウザのコンソールエラーを確認
4. ✅ 測定ID/ウェブサイトIDの形式が正しいことを確認
5. ✅ 広告ブロッカーが干渉していないか確認

**Dockerユーザーの場合：**

```bash
# 環境変数が設定されているか確認
docker exec new-api env | grep -E "GOOGLE_ANALYTICS|UMAMI"
```

---

### プライバシーに関する考慮事項

- Google Analyticsは、[Googleのプライバシーポリシー](https://policies.google.com/privacy)に従ってユーザーデータを収集します
- Umamiはプライバシーを重視しており、個人データを収集しません
- 分析ツールを使用する場合は、ウェブサイトにプライバシーポリシーを追加することを検討してください
- 両方のツールは、正しく設定されていればGDPR要件に準拠しています

---

## 環境変数リファレンス

| 変数 | 必須 | デフォルト値 | 説明 |
|------|------|--------|------|
| `GOOGLE_ANALYTICS_ID` | 否 | - | Google Analytics 4 測定ID（形式：G-XXXXXXXXXX）|
| `UMAMI_WEBSITE_ID` | 否 | - | Umami ウェブサイトID（UUID形式）|
| `UMAMI_SCRIPT_URL` | 否 | `https://analytics.umami.is/script.js` | Umami スクリプトURL（セルフホスティングのみ必要）|

---

## 関連リンク

- [Google Analytics](https://analytics.google.com/)
- [Umami Analytics](https://umami.is/)
- [Umami Documentation](https://umami.is/docs)
- [Google Analytics Privacy](https://support.google.com/analytics/answer/6004245)

---

## サポート

何か問題が発生した場合やご質問がある場合は、以下を行ってください：
- [GitHub](https://github.com/Calcium-Ion/new-api/issues) でイシューを提出
- 解決策については既存のイシューを確認