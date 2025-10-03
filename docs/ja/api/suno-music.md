## コアコンセプト (Core Concepts)

| 中文 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| 令牌 | Token | APIアクセス資格情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| 渠道 | Channel | APIサービスプロバイダーへのアクセスチャネル | Access channel for API service providers |
| 分组 | Group | ユーザーまたはトークンの分類。価格比率に影響を与える | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# Suno 音楽フォーマット（Music）

!!! note "ご注意ください"
    このインターフェースは **Suno公式のインターフェースではありません**。著者 **柏拉图** のオープンソースプロジェクト [**Suno-API**](https://github.com/Suno-API/Suno-API) に基づいて実装された Suno プロキシインターフェースです。

    ここで、Sunoの強力な機能を便利に利用できるようにしてくれた著者の方の貢献に深く感謝します。お時間があれば、ぜひ著者の方に Star をお願いします。

## 📝 概要 

Suno Music API は、以下を含む一連の音楽生成および処理機能を提供します。

- プロンプトに基づいて楽曲を生成（インスピレーションモード、カスタムモード）

- 既存の楽曲の続きを生成

- 複数のオーディオクリップを結合  

- 歌詞を生成

- オーディオをアップロード 

API を通じて、AI 音楽生成機能をアプリケーションに簡単に統合できます。

## 💡 リクエスト例

### 楽曲生成 ✅

```bash
curl --location 'https://你的newapi服务器地址/suno/submit/music' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
    "prompt":"[Verse]\nWalking down the streets\nBeneath the city lights\nNeon signs flickering\nLighting up the night\nHeart beating faster\nLike a drum in my chest\nI'\''m alive in this moment\nFeeling so blessed\n\nStilettos on the pavement\nStepping with grace\nSurrounded by the people\nMoving at their own pace\nThe rhythm of the city\nIt pulses in my veins\nLost in the energy\nAs my worries drain\n\n[Verse 2]\nConcrete jungle shining\nWith its dazzling glow\nEvery corner hiding secrets that only locals know\nA symphony of chaos\nBut it'\''s music to my ears\nThe hustle and the bustle\nWiping away my fears",
    "tags":"emotional punk",
    "mv":"chirp-v4",  
    "title":"City Lights"
}'
```

**応答例:**

```json
{
  "code":"success",
  "message":"",
  "data":"736a6f88-bd29-4b1e-b110-37132a5325ac"
}
```

### 歌詞生成 ✅

```bash
curl --location 'https://你的newapi服务器地址/suno/submit/lyrics' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
    "prompt":"dance"
}'
```

**応答例:**

```json
{
  "code":"success",
  "message":"",
  "data":"736a6f88-bd29-4b1e-b110-37132a5325ac" 
}
```

### オーディオアップロード ❌

```bash
curl --location 'https://你的newapi服务器地址/suno/uploads/audio-url' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \  
--header 'Content-Type: application/json' \
--data '{ 
    "url":"http://cdnimg.example.com/ai/2024-06-18/d416d9c3c34eb22c7d8c094831d8dbd0.mp3"
}'
```

**応答例:**

```json
{
  "code":"success",
  "message":"",
  "data":"736a6f88-bd29-4b1e-b110-37132a5325ac"
}  
```

### 楽曲結合 ❌

```bash
curl --location 'https://你的newapi服务器地址/suno/submit/concat' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \
--header 'Content-Type: application/json' \  
--data '{
    "clip_id":"extend 后的 歌曲ID", 
    "is_infill": false
}'
```

**応答例:**

```json
{
  "code":"success", 
  "message":"",
  "data":"736a6f88-bd29-4b1e-b110-37132a5325ac"  
}
```

### タスクステータスの照会 ✅

#### バッチ照会

```bash
curl --location 'https://你的newapi服务器地址/suno/fetch' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \ 
--header 'Content-Type: application/json' \
--data '{
    "ids":["task_id"], 
    "action":"MUSIC"
}'  
```

**応答例:**

```json
{
  "code":"success",
  "message":"", 
  "data":[
    {
      "task_id":"346c5d10-a4a1-4f49-a851-66a7dae6cfaf",
      "notify_hook":"",
      "action":"MUSIC", 
      "status":"IN_PROGRESS",
      "fail_reason":"",
      "submit_time":1716191749, 
      "start_time":1716191786,
      "finish_time":0,
      "progress":"0%",
      "data":[
        {
          "id":"e9893d04-6a63-4007-8473-64b706eca4d1",
          "title":"Electric Dance Party",
          "status":"streaming",
          "metadata":{
            "tags":"club banger high-energy edm",
            "prompt":"略",
            "duration":null,
            "error_type":null,
            "error_message":null, 
            "audio_prompt_id":null,
            "gpt_description_prompt":"miku dance"
          },
          "audio_url":"https://audiopipe.suno.ai/?item_id=e9893d04-6a63-4007-8473-64b706eca4d1",
          "image_url":"https://cdn1.suno.ai/image_e9893d04-6a63-4007-8473-64b706eca4d1.png",
          "video_url":"",
          "model_name":"chirp-v3", 
          "image_large_url":"https://cdn1.suno.ai/image_large_e9893d04-6a63-4007-8473-64b706eca4d1.png", 
          "major_model_version":"v3"
        }
      ]
    } 
  ] 
}
```

#### 単一照会

```bash
curl --location 'https://你的newapi服务器地址/suno/fetch/{{task_id}}' \ 
--header 'Authorization: Bearer $NEWAPI_API_KEY'
```

**応答例:**

```json
{
  "code":"success",
  "message":"",
  "data":{
    "task_id":"f4a94d75-087b-4bb1-bd45-53ba293faf96",
    "notify_hook":"", 
    "action":"LYRICS",
    "status":"SUCCESS",
    "fail_reason":"",
    "submit_time":1716192124, 
    "start_time":1716192124, 
    "finish_time":1716192124,
    "progress":"100%", 
    "data":{
      "id":"f4a94d75-087b-4bb1-bd45-53ba293faf96",
      "text":"略", 
      "title":"Electric Fantasy",
      "status":"complete"  
    }
  }
}
```

## 📮 リクエスト

すべてのリクエストは、リクエストヘッダーに認証情報を含める必要があります。

```
Authorization: Bearer $NEWAPI_API_KEY
```

### エンドポイント

#### 楽曲生成
```
POST /suno/submit/music  
```
新しい楽曲を生成します。インスピレーションモード、カスタムモード、続きの生成をサポートします。

#### 歌詞生成
```
POST /suno/submit/lyrics
```
プロンプトに基づいて歌詞を生成します。

#### オーディオアップロード
```  
POST /suno/uploads/audio-url
```
オーディオファイルをアップロードします。

#### 楽曲結合  
```
POST /suno/submit/concat
```
複数のオーディオクリップを結合して、完全な一曲の楽曲にします。

#### タスクステータスのバッチ照会
```
POST /suno/fetch  
```
複数のタスクのステータスと結果をバッチで取得します。

#### 単一タスクステータスの照会
```
GET /suno/fetch/{{task_id}}
```  
単一タスクのステータスと結果を照会します。

### リクエストボディパラメータ

#### 楽曲生成

##### `prompt`
- 型:String
- 必須:インスピレーションモードでは不要、カスタムモードでは必須
- 説明:歌詞の内容。カスタムモードで提供する必要があります。 

##### `mv`
- 型:String  
- 必須:いいえ
- 説明:モデルバージョン。オプション値: chirp-v3-0、chirp-v3-5。デフォルトは chirp-v3-0です。

##### `title` 
- 型:String
- 必須:インスピレーションモードでは不要、カスタムモードでは必須  
- 説明:楽曲のタイトル。カスタムモードで提供する必要があります。

##### `tags`
- 型:String
- 必須:インスピレーションモードでは不要、カスタムモードでは必須
- 説明:楽曲のスタイルタグ。カンマ区切りで、カスタムモードで提供する必要があります。

##### `make_instrumental`
- 型:Boolean 
- 必須:いいえ
- 説明:インストゥルメンタル（純粋な音楽）を生成するかどうか。true の場合、純粋な音楽を生成します。  

##### `task_id`
- 型:String
- 必須:続きを生成する際に必須
- 説明:続きを生成したい楽曲のタスク ID

##### `continue_at` 
- 型:Float
- 必須:続きを生成する際に必須
- 説明:楽曲の何秒目から続きを生成するか  

##### `continue_clip_id`
- 型:String 
- 必須:続きを生成する際に必須
- 説明:続きを生成したい楽曲のクリップ ID

##### `gpt_description_prompt`
- 型:String
- 必須:インスピレーションモードでは必須、その他のモードでは不要 
- 説明:インスピレーションの源となるテキスト記述

##### `notify_hook`
- 型:String
- 必須:いいえ 
- 説明:楽曲生成完了時のコールバック通知アドレス

#### 歌詞生成

##### `prompt` 
- 型:String
- 必須:はい
- 説明:歌詞のテーマまたはキーワード

##### `notify_hook`
- 型:String  
- 必須:いいえ
- 説明:歌詞生成完了時のコールバック通知アドレス

#### オーディオアップロード

##### `url`
- 型:String
- 必須:はい  
- 説明:アップロードするオーディオファイルの URL アドレス

#### 楽曲結合

##### `clip_id` 
- 型:String
- 必須:はい
- 説明:結合する楽曲クリップの ID

##### `is_infill`
- 型:Boolean
- 必須:否
- 説明:インフィルモード（埋め込みモード）であるかどうか  

#### タスク照会

##### `ids`
- 型:String[]
- 必須:はい
- 説明:照会するタスク ID のリスト

##### `action` 
- 型:String 
- 必須:いいえ
- 説明:タスクのタイプ。オプション値: MUSIC、LYRICS

## 📥 応答

すべてのインターフェースは、統一された JSON 形式の応答を返します。

```json
{
  "code":"success",
  "message":"",
  "data":"{{RESULT}}" 
}
```

### 成功応答

#### 基本応答フィールド

##### `code`
- 型:String
- 説明:リクエストステータス。success は成功を示します。 

##### `message` 
- 型:String
- 説明:リクエスト失敗時のエラーメッセージ

##### `data`
- 型:インターフェースによって異なる
- 説明:リクエスト成功時に返されるデータ
  - 楽曲生成、歌詞生成、オーディオアップロード、楽曲結合インターフェース: タスク ID 文字列を返します。
  - タスク照会インターフェース: タスクオブジェクトまたはタスクオブジェクトの配列を返します。

#### タスク関連オブジェクト

##### タスクオブジェクト
###### `task_id`
- 型:String  
- 説明:タスク ID

###### `notify_hook`
- 型:String
- 説明:タスク完了後のコールバック通知アドレス

###### `action`
- 型:String
- 説明:タスクタイプ。オプション値: MUSIC、LYRICS  

###### `status` 
- 型:String
- 説明:タスクステータス。オプション値: IN_PROGRESS、SUCCESS、FAIL

###### `fail_reason` 
- 型:String
- 説明:タスク失敗の原因  

###### `submit_time`
- 型:Integer
- 説明:タスク提出時のタイムスタンプ

###### `start_time`
- 型:Integer 
- 説明:タスク開始時のタイムスタンプ

###### `finish_time`
- 型:Integer
- 説明:タスク終了時のタイムスタンプ 

###### `progress`
- 型:String
- 説明:タスクの進捗パーセンテージ

###### `data`
- 型:タスクタイプによって異なる 
- 説明:
  - 音楽生成タスク: 楽曲オブジェクトの配列
  - 歌詞生成タスク: 歌詞オブジェクト  

##### 楽曲オブジェクト
###### `id`
- 型:String
- 説明:楽曲 ID

###### `title`
- 型:String
- 説明:楽曲タイトル

###### `status` 
- 型:String
- 説明:楽曲ステータス 

###### `metadata`
- 型:Object
- 説明:楽曲メタデータ
  - tags: 楽曲スタイルタグ
  - prompt: 楽曲生成に使用された歌詞
  - duration: 楽曲の長さ（デュレーション）
  - error_type: エラータイプ
  - error_message: エラーメッセージ
  - audio_prompt_id: オーディオプロンプト ID
  - gpt_description_prompt: インスピレーションの源となる記述

###### `audio_url`
- 型:String
- 説明:楽曲オーディオの URL アドレス

###### `image_url`
- 型:String
- 説明:楽曲カバー画像の URL アドレス  

###### `video_url` 
- 型:String
- 説明:楽曲ビデオの URL アドレス

###### `model_name`
- 型:String
- 説明:楽曲生成に使用されたモデル名

###### `major_model_version`
- 型:String 
- 説明:モデルのメジャーバージョン番号

##### 歌詞オブジェクト
###### `id`
- 型:String
- 説明:歌詞 ID

###### `text`
- 型:String 
- 説明:歌詞の内容

###### `title` 
- 型:String
- 説明:歌詞タイトル  

###### `status`
- 型:String
- 説明:歌詞ステータス

## 🌟 ベストプラクティス

1. できるだけ詳細で具体的な楽曲または歌詞の生成プロンプトを提供し、一般的すぎたり抽象的すぎたりすることを避けてください。

2. タスクステータスを照会する際、ポーリング間隔は 2〜5 秒を推奨します。頻繁すぎないようにしてください。

3. インスピレーションモードでは `gpt_description_prompt` パラメータのみを提供すれば、API が自動的に歌詞、タイトル、タグなどを生成します。

4. カスタムモードでは `prompt`、`title`、`tags` パラメータを提供する必要があります。これにより、楽曲に対してより多くの制御が可能になります。

5. 最新バージョンのモデル（例: chirp-v4）を使用するように努めてください。効果が向上します。

6. コールバック通知機能（`notify_hook` パラメータ）を使用すると、ポーリング頻度を減らし、効率を向上させることができます。

7. 音楽の続きの生成や結合機能は、元の音楽に基づいて、より豊かで完全な作品を生成できます。

8. ネットワークタイムアウトやパラメータ検証失敗など、発生しうる例外やエラーの処理に注意してください。