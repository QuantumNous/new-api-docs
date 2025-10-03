# Suno 音楽フォーマット（Music）

!!! note "ご注意ください"
    このインターフェースは **Suno公式のインターフェースではありません**。著者 **柏拉图** のオープンソースプロジェクト [**Suno-API**](https://github.com/Suno-API/Suno-API) に基づいて実装された Suno プロキシインターフェースです。

    Sunoの強力な機能を便利に利用できるようにしてくれた著者の貢献に深く感謝します。お時間があれば、ぜひ著者にStarをお願いします。

## 📝 概要 

Suno Music API は、以下を含む一連の音楽生成および処理機能を提供します:

- プロンプトに基づいた楽曲生成（インスピレーションモード、カスタムモード）

- 既存の楽曲の続きの作成

- 複数のオーディオクリップの結合  

- 歌詞の生成

- オーディオのアップロード 

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

### オーディオのアップロード ❌

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

### 楽曲の結合 ❌

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

#### 個別照会

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

すべてのリクエストは、リクエストヘッダーに認証情報を含める必要があります:

```
Authorization: Bearer $NEWAPI_API_KEY
```

### エンドポイント

#### 楽曲生成
```
POST /suno/submit/music  
```
新しい楽曲を生成します。インスピレーションモード、カスタムモード、続きの作成をサポートします。

#### 歌詞生成
```
POST /suno/submit/lyrics
```
プロンプトに基づいて歌詞を生成します。

#### オーディオのアップロード
```  
POST /suno/uploads/audio-url
```
オーディオファイルをアップロードします。

#### 楽曲の結合  
```
POST /suno/submit/concat
```
複数のオーディオクリップを結合して、完全な楽曲を作成します。

#### タスクステータスのバッチ照会
```
POST /suno/fetch  
```
複数のタスクのステータスと結果を一括で取得します。

#### 個別タスクステータスの照会
```
GET /suno/fetch/{{task_id}}
```  
単一のタスクのステータスと結果を照会します。

### リクエストボディパラメータ

#### 楽曲生成

##### `prompt`
- タイプ:String
- 必須:インスピレーションモードでは不要、カスタムモードでは必須
- 説明:歌詞の内容。カスタムモードで提供する必要があります。 

##### `mv`
- タイプ:String  
- 必須:否
- 説明:モデルバージョン。オプション値: chirp-v3-0、chirp-v3-5。デフォルトは chirp-v3-0です。

##### `title` 
- タイプ:String
- 必須:インスピレーションモードでは不要、カスタムモードでは必須  
- 説明:楽曲のタイトル。カスタムモードで提供する必要があります。

##### `tags`
- タイプ:String
- 必須:インスピレーションモードでは不要、カスタムモードでは必須
- 説明:楽曲のスタイルタグ。カンマ区切りで、カスタムモードで提供する必要があります。

##### `make_instrumental`
- タイプ:Boolean 
- 必須:否
- 説明:インストゥルメンタル（純粋な音楽）を生成するかどうか。true の場合、純粋な音楽を生成します。  

##### `task_id`
- タイプ:String
- 必須:続きを作成する際に必須
- 説明:続きを作成したい楽曲のタスク ID

##### `continue_at` 
- タイプ:Float
- 必須:続きを作成する際に必須
- 説明:楽曲の何秒目から続きを作成するか  

##### `continue_clip_id`
- タイプ:String 
- 必須:続きを作成する際に必須
- 説明:続きを作成したい楽曲のクリップ ID

##### `gpt_description_prompt`
- タイプ:String
- 必須:インスピレーションモードでは必須、その他のモードでは不要 
- 説明:インスピレーションの源となるテキスト記述

##### `notify_hook`
- タイプ:String
- 必須:否 
- 説明:楽曲生成完了時のコールバック通知アドレス

#### 歌詞生成

##### `prompt` 
- タイプ:String
- 必須:是
- 説明:歌詞のテーマまたはキーワード

##### `notify_hook`
- タイプ:String  
- 必須:否
- 説明:歌詞生成完了時のコールバック通知アドレス

#### オーディオのアップロード

##### `url`
- タイプ:String
- 必須:是  
- 説明:アップロードするオーディオファイルの URL アドレス

#### 楽曲の結合

##### `clip_id` 
- タイプ:String
- 必須:是
- 説明:結合する楽曲クリップの ID

##### `is_infill`
- タイプ:Boolean
- 必須:否
- 説明:インフィル（埋め込み）モードであるかどうか  

#### タスク照会

##### `ids`
- タイプ:String[]
- 必須:是
- 説明:照会するタスク ID のリスト

##### `action` 
- タイプ:String 
- 必須:否
- 説明:タスクタイプ。オプション値: MUSIC、LYRICS

## 📥 応答

すべてのインターフェースは、統一された JSON 形式の応答を返します:

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
- タイプ:String
- 説明:リクエストステータス。success は成功を示します。 

##### `message` 
- タイプ:String
- 説明:リクエスト失敗時のエラーメッセージ

##### `data`
- タイプ:異なるインターフェースによって異なります
- 説明:リクエスト成功時に返されるデータ
  - 楽曲生成、歌詞生成、オーディオアップロード、楽曲結合インターフェース: タスク ID 文字列を返します
  - タスク照会インターフェース: タスクオブジェクトまたはタスクオブジェクトの配列を返します

#### タスク関連オブジェクト

##### タスクオブジェクト
###### `task_id`
- タイプ:String  
- 説明:タスク ID

###### `notify_hook`
- タイプ:String
- 説明:タスク完了後のコールバック通知アドレス

###### `action`
- タイプ:String
- 説明:タスクタイプ。オプション値: MUSIC、LYRICS  

###### `status` 
- タイプ:String
- 説明:タスクステータス。オプション値: IN_PROGRESS、SUCCESS、FAIL

###### `fail_reason` 
- タイプ:String
- 説明:タスク失敗の理由  

###### `submit_time`
- タイプ:Integer
- 説明:タスク提出のタイムスタンプ

###### `start_time`
- タイプ:Integer 
- 説明:タスク開始のタイムスタンプ

###### `finish_time`
- タイプ:Integer
- 説明:タスク終了のタイムスタンプ 

###### `progress`
- タイプ:String
- 説明:タスク進捗のパーセンテージ

###### `data`
- タイプ:タスクタイプによって異なります 
- 説明:
  - 音楽生成タスク: 楽曲オブジェクトの配列
  - 歌詞生成タスク: 歌詞オブジェクト  

##### 楽曲オブジェクト
###### `id`
- タイプ:String
- 説明:楽曲 ID

###### `title`
- タイプ:String
- 説明:楽曲タイトル

###### `status` 
- タイプ:String
- 説明:楽曲ステータス 

###### `metadata`
- タイプ:Object
- 説明:楽曲メタデータ
  - tags: 楽曲スタイルタグ
  - prompt: 楽曲生成に使用された歌詞
  - duration: 楽曲の長さ（デュレーション）
  - error_type: エラータイプ
  - error_message: エラーメッセージ
  - audio_prompt_id: オーディオプロンプト ID
  - gpt_description_prompt: インスピレーションの源の記述

###### `audio_url`
- タイプ:String
- 説明:楽曲オーディオの URL アドレス

###### `image_url`
- タイプ:String
- 説明:楽曲カバー画像の URL アドレス  

###### `video_url` 
- タイプ:String
- 説明:楽曲ビデオの URL アドレス

###### `model_name`
- タイプ:String
- 説明:楽曲生成に使用されたモデル名

###### `major_model_version`
- タイプ:String 
- 説明:モデルのメジャーバージョン番号

##### 歌詞オブジェクト
###### `id`
- タイプ:String
- 説明:歌詞 ID

###### `text`
- タイプ:String 
- 説明:歌詞の内容

###### `title` 
- タイプ:String
- 説明:歌詞タイトル  

###### `status`
- タイプ:String
- 説明:歌詞ステータス

## 🌟 ベストプラクティス

1. できるだけ詳細で具体的な楽曲または歌詞生成プロンプトを提供し、包括的または抽象的になりすぎないようにします。

2. タスクステータスを照会する際、ポーリング間隔は2〜5秒を推奨します。頻繁になりすぎないようにしてください。

3. インスピレーションモードでは `gpt_description_prompt` パラメータのみを提供すれば、API が自動的に歌詞、タイトル、タグなどを生成します。

4. カスタムモードでは `prompt`、`title`、`tags` パラメータを提供する必要があります。これにより、楽曲をより細かく制御できます。

5. 可能な限り最新バージョンのモデル（例：`chirp-v4`）を使用すると、より良い結果が得られます。

6. コールバック通知機能（`notify_hook` パラメータ）を使用すると、ポーリング頻度を減らし、効率を向上させることができます。

7. 楽曲の続きの作成や結合機能は、元の音楽に基づいて、より豊かで完全な作品を生成できます。

8. ネットワークタイムアウトやパラメータ検証失敗など、発生しうる例外やエラーの処理に注意してください。