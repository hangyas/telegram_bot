require "http/client"
require "json"
require "./helper.cr"
require "./types/*"

require "./http_client_mulipart.cr"

module TelegramBot
  abstract class Bot
    abstract def handle(update : Update)

    def initialize(@name : String, @token : String)
      @nextoffset = 0
    end

    def polling
      #      loop do
      updates = get_updates
      updates.each do |u|
        handle u
      end
      #      end
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
      pp response
      #      if response.status_code != 200
      # pp response.body
      #       return # TODO error msg? irunk sajat hiba kodos jsont
      #    end

      #      pp response.body

      json = JSON.parse(response.body) # Hash(String, JSON::Type)
      json["result"]
    end

    def get_me
      request "getMe"
    end

    private def get_updates(offset = @nextoffset, limit = nil : Int32?, timeout = nil : Int32?)
      data = request "getUpdates", {"offset": "#{offset}"}

      r = [] of Update
      data.each do |json|
        r << Update.from_json(json.to_json)
        msg = r.last.message
        if msg
          if msg.text
            p msg.text
          end
        end
      end

      if !r.empty?
        @nextoffset = r.last.update_id + 1
      end
      r
    end

    def send_message(chat_id : Int32 | String, text : String, parse_mode = nil : String?, disable_web_view = nil : Boolean?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      request "sendMessage", {
        "chat_id":             chat_id,
        "text":                text,
        "parse_mode":          parse_mode,
        "disable_web_view":    disable_web_view,
        "reply_to_message_id": reply_to_message_id,
        "reply_markup":        reply_markup,
      }
    end

    def reply(message : Message, text : String)
      send_message(message.chat.id, text, reply_to_message_id: message.message_id)
    end

    def forward_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32)
    end

    def send_photo(chat_id : Int32 | String, photo = nil : ::File?, caption = nil : String?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      request "sendPhoto", {
        "chat_id":             chat_id,
        "photo":               photo,
        "reply_to_message_id": reply_to_message_id,
        "reply_markup":        reply_markup,
      }
    end

    def send_audio(chat_id : Int32 | String, audio : ::File, duration = nil : Int32?, performer = nil : String?, title = nil : String?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      request "sendPhoto", {
        "chat_id":             chat_id,
        "audio":               audio,
        "duration":            duration,
        "performer":           performer,
        "title":               title,
        "reply_to_message_id": reply_to_message_id,
        "reply_markup":        reply_markup,
      }
    end

    def send_document(chat_id : Int32 | String, document : String, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
    end

    # TODO from file
    def send_sticker(chat_id : Int32 | String, sticker : String, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
    end

    # TODO from file
    def send_video(chat_id : Int32 | String, video : String, duration = nil : Int32?, caption = nil : String?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
    end

    # TODO from file
    def send_voice(chat_id : Int32 | String, voice : String, duration = nil : Int32?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
    end

    def send_location(chat_id : Int32 | String, latitude : Float, longitude : Float, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
    end
  end
end
