# FluentRead (流暢な読書) - オープンソース翻訳プラグイン

!!! tip "チャット設定オプション"
    New API コンソールのシステム設定 -> チャット設定で、以下のショートカットオプションを追加できます。これにより、トークン管理ページから FluentRead へワンクリックで設定を反映できます：

    ```json
    { "流畅阅读": "fluentread" }
    ```

!!! info
    🌊 FluentRead（流暢な読書）は、母国語のような読書体験を提供することを目指したオープンソースのブラウザ翻訳プラグインです。

    - プロジェクトアドレス：<https://github.com/Bistutu/FluentRead>

## 🌟 コア機能

### スマート翻訳エンジン
- **多エンジンサポート**：20種類以上の翻訳エンジンをサポート
- **従来の翻訳**：Microsoft 翻訳、Google 翻訳、DeepL 翻訳など
- **AI大規模モデル**：OpenAI、DeepSeek、Kimi、Ollamaなど
- **カスタムエンジン**：カスタム翻訳サービスの設定をサポート

### 没入型読書体験
- **バイリンガル対照**：原文と翻訳文を並列表示し、より簡単に読書
- **選択範囲翻訳**：任意のテキストを選択すると、即座に翻訳結果を取得
- **ワンクリックコピー**：翻訳文を素早くコピーし、読書効率を向上
- **全文翻訳**：フローティングボタンでウェブページ全体をワンクリックで翻訳、ページのリフレッシュは不要

### プライバシーとカスタマイズ
- **プライバシー保護**：すべてのデータはローカルに保存され、コードはオープンソースで透明
- **高度なカスタマイズ**：豊富なカスタムオプションにより、さまざまなシーンのニーズに対応
- **完全無料**：オープンソースで無料、非営利プロジェクト

## 📦 インストール方法

| ブラウザ | インストール方法 |
|--------|----------|
| **Chrome** | [Chrome ウェブストア](https://chromewebstore.google.com/detail/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/djnlaiohfaaifbibleebjggkghlmcpcj?hl=zh-CN&authuser=0) \| [国内ミラー](https://www.crxsoso.com/webstore/detail/djnlaiohfaaifbibleebjggkghlmcpcj) |
| **Edge** | [Edge アドオンストア](https://microsoftedge.microsoft.com/addons/detail/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/kakgmllfpjldjhcnkghpplmlbnmcoflp?hl=zh-CN) |
| **Firefox** | [Firefox アドオンストア](https://addons.mozilla.org/zh-CN/firefox/addon/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/) |

## 🚀 設定方法

### New API コンソールからの設定インポート（推奨）

ブラウザにFluentReadプラグインがインストールされている状態で、New API コンソール -> トークン管理ページを開くと、FluentReadを追加するためのプロンプトが表示されます。

![添加提示](../assets/fluentread/hint.png)

モデルを選択した後、「一键填充到FluentRead (FluentReadへワンクリックで反映)」をクリックすると、確認ウィンドウが表示され、対応する情報が正しいかチェックされます。

![确认](../assets/fluentread/confirm.png)

インポートを確認すると、FluentRead内のNew API設定が有効になります。

![配置结果](../assets/fluentread/fluentread.png)

### FluentReadで手動で設定を入力

![手动配置](../assets/fluentread/configuration.png)

| 設定項目 | 内容 |
|--------|----------|
| 翻訳サービス | NewAPI |
| アクセストークン | NewAPI キー |
| NewAPIインターフェース | NewAPIデプロイアドレス（/v1を含まない） |
| モデル | リストから選択、またはカスタムモデル |
| カスタムモデル | モデル名 |