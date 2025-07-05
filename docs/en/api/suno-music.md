# Suno Music Format (Music)

!!! note "Please Note"
    This interface is **not an official Suno interface**, but rather a Suno proxy interface implemented based on the open-source project [**Suno-API**](https://github.com/Suno-API/Suno-API) by author **Plato**.

    We are very grateful for the author's contribution, which allows us to easily use Suno's powerful features. If you have time, please give the author a Star.

## 📝 Introduction 

Suno Music API provides a series of music generation and processing functions, including:

- Generate songs based on prompts (Inspiration mode, Custom mode)

- Continue writing existing songs

- Concatenate multiple audio segments

- Generate lyrics

- Upload audio

Through the API, you can easily integrate AI music generation capabilities into your applications.

## 💡 Request Examples

### Generate Song ✅

```bash
curl --location 'https://your-newapi-server-address/suno/submit/music' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
    "prompt":"[Verse]\nWalking down the streets\nBeneath the city lights\nNeon signs flickering\nLighting up the night\nHeart beating faster\nLike a drum in my chest\nI'\''m alive in this moment\nFeeling so blessed\n\nStilettos on the pavement\nStepping with grace\nSurrounded by the people\nMoving at their own pace\nThe rhythm of the city\nIt pulses in my veins\nLost in the energy\nAs my worries drain\n\n[Verse 2]\nConcrete jungle shining\nWith its dazzling glow\nEvery corner hiding secrets that only locals know\nA symphony of chaos\nBut it'\''s music to my ears\nThe hustle and the bustle\nWiping away my fears",
    "tags":"emotional punk",
    "mv":"chirp-v4",  
    "title":"City Lights"
}'
```

**Response Example:**

```json
{
  "code":"success",
  "message":"",
  "data":"736a6f88-bd29-4b1e-b110-37132a5325ac"
}
```

### Generate Lyrics ✅

```bash
curl --location 'https://your-newapi-server-address/suno/submit/lyrics' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
    "prompt":"dance"
}'
```

**Response Example:**

```json
{
  "code":"success",
  "message":"",
  "data":"736a6f88-bd29-4b1e-b110-37132a5325ac" 
}
```

### Upload Audio ❌

```bash
curl --location 'https://your-newapi-server-address/suno/uploads/audio-url' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \  
--header 'Content-Type: application/json' \
--data '{ 
    "url":"http://cdnimg.example.com/ai/2024-06-18/d416d9c3c34eb22c7d8c094831d8dbd0.mp3"
}'
```

**Response Example:**

```json
{
  "code":"success",
  "message":"",
  "data":"736a6f88-bd29-4b1e-b110-37132a5325ac"
}  
```

### Song Concatenation ❌

```bash
curl --location 'https://your-newapi-server-address/suno/submit/concat' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \
--header 'Content-Type: application/json' \  
--data '{
    "clip_id":"extend song ID", 
    "is_infill": false
}'
```

**Response Example:**

```json
{
  "code":"success", 
  "message":"",
  "data":"736a6f88-bd29-4b1e-b110-37132a5325ac"  
}
```

### Query Task Status ✅

#### Batch Query

```bash
curl --location 'https://your-newapi-server-address/suno/fetch' \
--header 'Authorization: Bearer $NEWAPI_API_KEY' \ 
--header 'Content-Type: application/json' \
--data '{
    "ids":["task_id"], 
    "action":"MUSIC"
}'  
```

**Response Example:**

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
            "prompt":"omitted",
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

#### Single Query

```bash
curl --location 'https://your-newapi-server-address/suno/fetch/{{task_id}}' \ 
--header 'Authorization: Bearer $NEWAPI_API_KEY'
```

**Response Example:**

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
      "text":"omitted", 
      "title":"Electric Fantasy",
      "status":"complete"  
    }
  }
}
```

## 📮 Request

All requests must include authentication information in the request header:

```
Authorization: Bearer $NEWAPI_API_KEY
```

### Endpoints

#### Generate Song
```
POST /suno/submit/music  
```
Generate new songs, supporting inspiration mode, custom mode, and continuation.

#### Generate Lyrics
```
POST /suno/submit/lyrics
```
Generate lyrics based on prompts.

#### Upload Audio
```  
POST /suno/uploads/audio-url
```
Upload audio files.

#### Song Concatenation  
```
POST /suno/submit/concat
```
Concatenate multiple audio segments into a complete song.

#### Batch Query Task Status
```
POST /suno/fetch  
```
Batch get the status and results of multiple tasks.

#### Query Single Task Status
```
GET /suno/fetch/{{task_id}}
```  
Query the status and results of a single task.

### Request Body Parameters

#### Generate Song

##### `prompt`
- Type:String
- Required:Inspiration mode does not require, custom mode requires
- Description:Lyric content, needs to be provided in custom mode

##### `mv`
- Type:String  
- Required:No
- Description:Model version, optional values: chirp-v3-0, chirp-v3-5, default is chirp-v3-0

##### `title` 
- Type:String
- Required:Inspiration mode does not require, custom mode requires  
- Description:Song title, needs to be provided in custom mode

##### `tags`
- Type:String
- Required:Inspiration mode does not require, custom mode requires
- Description:Song style tags, separated by commas, needs to be provided in custom mode

##### `make_instrumental`
- Type:Boolean 
- Required:No
- Description:Whether to generate pure music, true means generate pure music  

##### `task_id`
- Type:String
- Required:Required when continuing
- Description:The task ID of the song to be continued

##### `continue_at` 
- Type:Float
- Required:Required when continuing
- Description:Continue writing from which second of the song  

##### `continue_clip_id`
- Type:String 
- Required:Required when continuing
- Description:The clip ID of the song to be continued

##### `gpt_description_prompt`
- Type:String
- Required:Required in inspiration mode, not required in other modes 
- Description:Text description of the source of inspiration

##### `notify_hook`
- Type:String
- Required:No 
- Description:Callback address for song generation completion

#### Generate Lyrics

##### `prompt` 
- Type:String
- Required:Yes
- Description:Thematic or keyword of lyrics

##### `notify_hook`
- Type:String  
- Required:No
- Description:Callback address for lyric generation completion

#### Upload Audio

##### `url`
- Type:String
- Required:Yes  
- Description:URL address of the audio file to be uploaded

#### Song Concatenation

##### `clip_id` 
- Type:String
- Required:Yes
- Description:ID of the song segment to be concatenated

##### `is_infill`
- Type:Boolean
- Required:No
- Description:Whether it is fill mode  

#### Task Query

##### `ids`
- Type:String[]
- Required:Yes
- Description:List of task IDs to be queried

##### `action` 
- Type:String 
- Required:No
- Description:Task type, optional values: MUSIC, LYRICS

## 📥 Response

All interfaces return a unified JSON format response:

```json
{
  "code":"success",
  "message":"",
  "data":"{{RESULT}}" 
}
```

### Successful Response

#### Basic Response Fields

##### `code`
- Type:String
- Description:Request status, success means success 

##### `message` 
- Type:String
- Description:Error message when request fails

##### `data`
- Type:Different for different interfaces
- Description:Return data when request is successful
  - Generate song, lyrics, upload audio, song concatenation interfaces: return task ID string
  - Task query interfaces: return task object or task object array

#### Task Related Objects

##### Task Object
###### `task_id`
- Type:String  
- Description:Task ID

###### `notify_hook`
- Type:String
- Description:Callback address after task completion

###### `action`
- Type:String
- Description:Task type, optional values: MUSIC, LYRICS  

###### `status` 
- Type:String
- Description:Task status, optional values: IN_PROGRESS, SUCCESS, FAIL

###### `fail_reason` 
- Type:String
- Description:Task failure reason  

###### `submit_time`
- Type:Integer
- Description:Task submission timestamp

###### `start_time`
- Type:Integer 
- Description:Task start timestamp

###### `finish_time`
- Type:Integer
- Description:Task end timestamp 

###### `progress`
- Type:String
- Description:Task progress percentage

###### `data`
- Type:Different for different task types 
- Description:
  - Music generation task: song object array
  - Lyrics generation task: lyrics object  

##### Song Object
###### `id`
- Type:String
- Description:Song ID

###### `title`
- Type:String
- Description:Song title

###### `status` 
- Type:String
- Description:Song status 

###### `metadata`
- Type:Object
- Description:Song metadata
  - tags:Song style tags
  - prompt:Lyric used to generate song
  - duration:Song duration
  - error_type:Error type
  - error_message:Error message
  - audio_prompt_id:Audio prompt ID
  - gpt_description_prompt:Description of inspiration source

###### `audio_url`
- Type:String
- Description:URL address of song audio

###### `image_url`
- Type:String
- Description:URL address of song cover image  

###### `video_url` 
- Type:String
- Description:URL address of song video

###### `model_name`
- Type:String
- Description:Model name used to generate song

###### `major_model_version`
- Type:String 
- Description:Major model version

##### Lyrics Object
###### `id`
- Type:String
- Description:Lyrics ID

###### `text`
- Type:String 
- Description:Lyrics content

###### `title` 
- Type:String
- Description:Lyrics title  

###### `status`
- Type:String
- Description:Lyrics status

## 🌟 Best Practices

1. Provide as detailed and specific song or lyric generation prompts as possible, avoiding overly general or abstract prompts

2. When querying task status, polling intervals are recommended to be 2-5 seconds to avoid excessive polling

3. Inspiration mode only needs to provide the gpt_description_prompt parameter, the API will automatically generate lyrics, titles, tags, etc.

4. Custom mode requires prompt, title, tags parameters, which can have more control over the song

5. Try to use the latest model (such as chirp-v4), the effect will be better

6. Using the callback notification function (notify_hook parameter) can reduce polling frequency and improve efficiency

7. Music continuation and concatenation functions can generate more rich and complete works on the original music

8. Pay attention to possible exceptions and errors, such as network timeouts, parameter validation failures, etc.