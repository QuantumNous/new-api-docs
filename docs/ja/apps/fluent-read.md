## コアコンセプト (Core Concepts)

| 中国語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# FluentRead（流暢な読書） - オープンソース翻訳プラグイン

!!! tip "チャット設定オプション"
    New API コンソールのシステム設定 -> チャット設定で、以下のショートカットオプションを追加できます。これにより、トークン管理ページからFluentReadへワンクリックで設定を投入できます：

    ```json
    { "流畅阅读": "fluentread" }
    ```

!!! info
    🌊 FluentRead（流暢な読書）は、母国語のような読書体験を提供することを目指した、オープンソースのブラウザ翻訳プラグインです。

    - プロジェクトアドレス：<https://github.com/Bistutu/FluentRead>

## 🌟 コア機能

### スマート翻訳エンジン
- **マルチエンジンサポート**：20種類以上の翻訳エンジンをサポート
- **従来型翻訳**：Microsoft 翻訳、Google 翻訳、DeepL 翻訳など
- **AI 大規模モデル**：OpenAI、DeepSeek、Kimi、Ollamaなど
- **カスタムエンジン**：カスタム翻訳サービスの設定をサポート

### 没入型読書体験
- **バイリンガル対照表示**：原文と翻訳文を並列表示し、より楽な読書を実現
- **単語選択翻訳**：任意のテキストを選択すると、即座に翻訳結果を取得
- **ワンクリックコピー**：翻訳文を素早くコピーし、読書効率を向上
- **全文翻訳**：フローティングボタンでウェブページ全体をワンクリック翻訳。ページのリフレッシュは不要です

### プライバシーとカスタマイズ
- **プライバシー保護**：すべてのデータはローカルに保存され、コードはオープンソースで透明性が確保されています
- **高度なカスタマイズ**：豊富なカスタムオプションにより、さまざまなシーンのニーズに対応
- **完全無料**：オープンソースかつ無料で、非営利プロジェクトです

## 📦 インストール方法

| ブラウザ | インストール方法 |
|--------|----------|
| **Chrome** | [Chrome ウェブストア](https://chromewebstore.google.com/detail/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/djnlaiohfaaifbibleebjggkghlmcpcj?hl=zh-CN&authuser=0) \| [国内ミラー](https://www.crxsoso.com/webstore/detail/djnlaiohfaaifbibleebjggkghlmcpcj) |
| **Edge** | [Edge アドオンストア](https://microsoftedge.microsoft.com/addons/detail/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/kakgmllfpjldjhcnkghpplmlbnmcoflp?hl=zh-CN) |
| **Firefox** | [Firefox アドオンストア](https://addons.mozilla.org/zh-CN/firefox/addon/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/) |

## 🚀 設定方法

### New API コンソールから設定をインポート（推奨）

ブラウザにFluentReadプラグインがインストールされている状態で、New API コンソール -> トークン管理ページを開くと、FluentReadを追加するためのプロンプトが表示されます

![追加プロンプト](../assets/fluentread/hint.png)

モデルを選択した後、「FluentReadにワンクリックで投入」をクリックすると、確認ウィンドウがポップアップ表示され、対応する情報が正しいかチェックできます

![確認](../assets/fluentread/confirm.png)

インポートを確認すると、FluentRead内のNew API設定が有効になります

![設定結果](../assets/fluentread/fluentread.png)

### FluentReadで手動で設定を入力する

![手動設定](../assets/fluentread/configuration.png)

| 設定項目 | 内容 |
|--------|----------|
| 翻訳サービス | NewAPI |
| アクセストークン | New API キー |
| NewAPIインターフェース | New APIデプロイアドレス（/v1を含まない） |
| モデル | リストから選択、またはカスタムモデル |
| カスタムモデル | モデル名 |