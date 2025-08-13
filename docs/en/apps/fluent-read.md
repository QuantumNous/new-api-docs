# FluentRead - Open Source Translation Plugin

!!! tip "Chat settings option"
    In the New API Console under System Settings -> Chat settings, you can add the following quick option to enable one-click fill to FluentRead from the API Keys page:

    ```json
    { "FluentRead": "fluentread" }
    ```

!!! info
    🌊 FluentRead is a revolutionary open-source browser translation plugin, enabling everyone to have a native-like reading experience.

    - Project Address: <https://github.com/Bistutu/FluentRead>

## 🌟 Core Features

### Intelligent Translation Engine
- **Multi-engine Support**: Supports 20+ translation engines
- **Traditional Translation**: Microsoft Translator, Google Translate, DeepL, etc.
- **AI Large Models**: OpenAI, DeepSeek, Kimi, Ollama, etc.
- **Custom Engines**: Support for custom translation service configuration

### Immersive Reading Experience
- **Bilingual Display**: Original text and translation displayed side by side for easier reading
- **Word Selection Translation**: Select any text to get instant translation results
- **One-click Copy**: Quickly copy translations to improve reading efficiency
- **Full-page Translation**: Use the floating ball to translate entire web pages with one click, no page refresh needed

### Privacy and Customization
- **Privacy Protection**: All data stored locally, open source and transparent code
- **Highly Customizable**: Rich customization options to meet different scenario needs
- **Completely Free**: Open source and free, non-commercial project

## 📦 Installation Methods

| Browser | Installation Method |
|---------|-------------------|
| **Chrome** | [Chrome Web Store](https://chromewebstore.google.com/detail/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/djnlaiohfaaifbibleebjggkghlmcpcj?hl=zh-CN&authuser=0) \| [Domestic Mirror](https://www.crxsoso.com/webstore/detail/djnlaiohfaaifbibleebjggkghlmcpcj) |
| **Edge** | [Edge Add-ons Store](https://microsoftedge.microsoft.com/addons/detail/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/kakgmllfpjldjhcnkghpplmlbnmcoflp?hl=zh-CN) |
| **Firefox** | [Firefox Add-ons Store](https://addons.mozilla.org/zh-CN/firefox/addon/%E6%B5%81%E7%95%85%E9%98%85%E8%AF%BB/) |

## 🚀 Configuration Methods

### Import Configuration from New API Console (Recommended)

After installing the FluentRead plugin in your browser, open the New API Console->Token Management page and a prompt to add FluentRead will appear

![Add Hint](../assets/fluentread/hint.png)

Select a model and click "One-click Fill to FluentRead", which will pop up a confirmation window. Check if the corresponding information is correct

![Confirm](../assets/fluentread/confirm.png)

After confirming the import, the New API configuration in FluentRead will be enabled

![Configuration Result](../assets/fluentread/fluentread.png)

### Manual Configuration in FluentRead

![Manual Configuration](../assets/fluentread/configuration.png)

| Configuration Item | Content |
|-------------------|---------|
| Translation Service | NewAPI |
| Access Token | NewAPI Key |
| NewAPI Interface | NewAPI deployment address (without /v1) |
| Model | Select from list, or custom model |
| Custom Model | Model name |

