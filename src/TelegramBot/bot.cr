require "http/client"
require "json"
require "./helper.cr"
require "./types/*"

require "./http_client_multipart.cr"

module TelegramBot
  abstract class Bot
    abstract def handle(message : Message)

    def handle(inline_query : InlineQuery)
    end

    def handle(inline_query : ChoosenInlineResult)
    end

    def initialize(@name : String, @token : String)
      @nextoffset = 0
    end

    def polling
      loop do
        updates = get_updates
        updates.each do |u|
          if msg = u.message
            handle msg
            if msg.text
              p msg.text
            end
          elsif query = u.inline_query
            handle query
          elsif choosen = u.choosen_inline_result
            handle choosen
          end
        end
      end
    end

    private def request(method : String, params = {} of String => String)
      headers = HTTP::Headers.new
      parts = HTTP::Client::MultipartBody.new

      params.each do |k, v|
        if v.nil?
          next
        end
        if v.is_a?(::File)
          parts.add_file(k, v)
        else
          parts.add_part(k, v.to_s)
        end
      end

      response = HTTP::Client.post_multipart "https://api.telegram.org/bot#{@token}/#{method}", headers, parts

      if response.status_code == 200
        json = JSON.parse(response.body)
        if json["ok"]
          return json["result"]
        else
          pp json
          return JSON.parse %({})
        end
      else
        pp response.status_code
        p response.body
        return JSON.parse %({})
      end
    end

    def get_me
      request "getMe"
    end

    private def get_updates(offset = @nextoffset, limit = nil : Int32?, timeout = nil : Int32?)
      data = request "getUpdates", {"offset": "#{offset}"}

      r = [] of Update
      data.each do |json|
        r << Update.from_json(json.to_json)
      end

      if !r.empty?
        @nextoffset = r.last.update_id + 1
      end
      r
    end

    macro def_request(name, *args)
        request {{name}}, {
          {% for arg in args %}
            {{arg.stringify}} : {{arg.id}},
          {% end %}
        }
    end

    def send_message(chat_id : Int32 | String, text : String, parse_mode = nil : String?, disable_web_view = nil : Boolean?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil) : Message
      res = def_request "sendMessage", chat_id, text, parse_mode, disable_web_view, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def reply(message : Message, text : String) : Message
      send_message(message.chat.id, text, reply_to_message_id: message.message_id)
    end

    def forward_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32)
      res = def_request "forwardMessage", chat_id, from_chat_id, message_id
      Message.from_json res.to_json
    end

    def send_photo(chat_id : Int32 | String, photo : ::File | String, caption = nil : String?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      res = def_request "sendPhoto", chat_id, photo, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_audio(chat_id : Int32 | String, audio : ::File | String, duration = nil : Int32?, performer = nil : String?, title = nil : String?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      res = def_request "sendPhoto", chat_id, audio, duration, performer, title, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_document(chat_id : Int32 | String, document : ::File | String, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      res = def_request "sendDocument", chat_id, document, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_sticker(chat_id : Int32 | String, sticker : ::File | String, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      res = def_request "sendSticker", chat_id, sticker, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_video(chat_id : Int32 | String, video : ::File | String, duration = nil : Int32?, caption = nil : String?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      res = def_request "sendVideo", chat_id, video, duration, caption, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_voice(chat_id : Int32 | String, voice : ::File | String, duration = nil : Int32?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      res = def_request "sendVoice", chat_id, voice, duration, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_location(chat_id : Int32 | String, latitude : Float, longitude : Float, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      res = def_request "sendLocation", chat_id, latitude, longitude, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def answer_inline_query(inline_query_id : String, result_array : Array(InlineQueryResult), cache_time = nil : Int32?, is_personal = nil : Boolean?, next_offset = nil : String?) : Bool
      # results   Array of InlineQueryResult  Yes   A JSON-serialized array of results for the inline query
      results = "[" + result_array.join(", ") { |a| a.to_json } + "]"
      res = def_request "answerInlineQuery", inline_query_id, results, cache_time, is_personal, next_offset

      if res.is_a?(Bool)
        return res
      else
        return false
      end
    end

    def get_file(file_id : String) : File
      res = def_request "getFile", file_id
      File.from_json(res.to_json)
    end

    def download(media)
      download(get_file(media.file_id))
    end

    def download(file : File)
      download(file.file_path!)
    end

    def download(file_path : String)
      HTTP::Client.get("https://api.telegram.org/file/bot#{@token}/#{file_path}").body
    end
  end
end
