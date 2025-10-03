# LunaTranslator - オープンソース GalGame 翻訳ツール
!!! tip "チャット設定オプション"
    New API コンソールのシステム設定 -> チャット設定で、以下のショートカットオプションを追加できます。これにより、トークン管理ページから LunaTranslator へワンクリックで設定を投入できます：

    ```json
    { "LunaTranslator": "lunatranslator://llmapi/base64?data={cheryConfig}" }
    ```

!!! info
    LunaTranslator は、オープンソースで無料のビジュアルノベル（GalGame）翻訳ツールであり、ネイティブレベルのビジュアルノベルプレイ体験を提供することを目指しています。

    - プロジェクトアドレス：<https://github.com/HIllya51/LunaTranslator>
    - プロジェクトドキュメント：<https://docs.lunatranslator.org/zh/README.html>

## 機能サポート

- **HOOK** 主にHOOKを使用してゲームテキストを抽出し、ほぼすべての一般的およびマイナーなビジュアルノベルに対応しています。

- **インライン翻訳** 一部のゲームでは、没入感のある体験を得るために、翻訳をゲーム内に直接組み込むことができます。

- **HOOKエミュレータ** NS/PSP/PSV/PS2上のほとんどのゲームについて、HOOKエミュレータによるゲームテキストの直接読み取りをサポートしています。

- **OCR** 高精度のOCRモデルを内蔵しており、柔軟に任意のテキストを読み取れるよう、他の多くのオンライン＆オフラインOCRエンジンもサポートしています。

- **豊富な翻訳インターフェース** 大規模言語モデル翻訳、オフライン翻訳など、ほぼすべての翻訳エンジンをサポートしています。

- **言語学習** 日本語の分かち書きとふりがな表示、AnkiConnect、Yomitanプラグインをサポートしています。

- **音声合成** 多数のオンライン＆オフライン音声合成エンジンをサポートしています。

- **音声認識** Windows 10およびWindows 11では、Windows音声認識を使用できます。

## インストール方法 

[LunaTranslator ドキュメント - ダウンロード & 起動 & 更新](https://docs.lunatranslator.org/zh/README.html) からダウンロードおよびインストールを行ってください。

## LunaTranslator で NewAPI を連携する

LunaTranslator は、ローカルにデプロイされた NewAPI および、NewAPI を使用して構築されたサードパーティの NewAPI サービスへの連携をサポートしています。

### ワンクリック設定
1. New API コンソールの`システム設定` -> `チャット設定`で、以下のショートカットオプションを追加します：
    
    ```json
    { "LunaTranslator": "lunatranslator://llmapi/base64?data={cheryConfig}" }
    ```
   
    ![add_config](../assets/luna_translator/add_config.png)

2. **`NewAPI`** -> `コンソール` -> `トークン管理` タブで、LunaTranslator で使用したいトークンを選択し、チャットボタンの隣にあるドロップダウンオプションをクリックして `LunaTranslator` を選択します。これにより、LunaTranslator にジャンプし、APIアドレスとAPI Keyが自動的に設定されます。

    ![跳转到 LunaTranslator](../assets/luna_translator/jump_to_app.png)

3. **`LunaTranslator`** -> `設定` -> `翻訳設定` -> `大規模モデル` に、新しく追加された大規模モデルインターフェース設定が表示されるので、編集をクリックします。

    ![设置api](../assets/luna_translator/api_setting.png)

4. **model** ドロップダウンボックスの隣にある更新ボタンをクリックして、New API プラットフォームのモデルリストを取得し、モデル名を選択または入力した後、完了したら確定をクリックして保存します。

    ![设置模型](../assets/luna_translator/setting_model.png)

5. **new_api** 大規模モデルインターフェース設定の隣にあるスイッチボタンがオンになっているか確認し、有効になっていない場合はインターフェースを有効にすれば使用を開始できます。

    ![开启配置](../assets/luna_translator/open_config.png)

### 手動設定

1. **`NewAPI`** -> `コンソール` -> `トークン管理` タブで API Key を取得します。

    ![获取 API Key](../assets/luna_translator/copy_api_key.png)

2. **`LunaTranslator`** -> `設定` -> `翻訳設定` -> `大規模モデル` で追加を選択します。

    ![添加 API](../assets/luna_translator/add_api.png)

3. **大規模モデル汎用インターフェース** テンプレートをコピーし、新しいインターフェースを追加します。

    ![添加 API2](../assets/luna_translator/add_api_2.png)

4. **新しく追加されたインターフェース** に、対応する API アドレスと API Key を入力します。

    ![设置 API1](../assets/luna_translator/setting_api.png)

    ![设置 API2](../assets/luna_translator/setting_api2.png)

5. **model** ドロップダウンボックスの隣にある更新ボタンをクリックして、New API プラットフォームのモデルリストを取得し、モデル名を選択または入力した後、完了したら確定をクリックして保存します。

    ![设置 API3](../assets/luna_translator/setting_api3.png)

6. **NewAPI** の隣にあるスイッチボタンをクリックしてインターフェースを有効にすれば、使用を開始できます。

    ![打开API](../assets/luna_translator/open_api.png)

その他の使用方法については、LunaTranslator 公式ドキュメントを参照してください:[LunaTranslator ドキュメント - 大規模モデル翻訳インターフェース](https://docs.lunatranslator.org/zh/guochandamoxing.html)