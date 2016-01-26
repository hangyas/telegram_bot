require "http/client"
require "json"
require "./helper.cr"
require "./types/*"

module TelegramBot
  abstract class Bot
    abstract def handle(update : Update)

    def initialize(@name : String, @token : String)
      @nextoffset = 0
    end

    def polling
      loop do
        updates = get_updates
        updates.each do |u|
          handle u
        end
      end
    end

    private def request(method : String, params = {} of String => String, file = nil : File?)
      params.delete_if do |k, v|
        v.nil?
      end

      headers = HTTP::Headers.new
      #      params.each do |k, v|
      #       headers[k] = v.to_s
      #    end

      body = nil

      if file # TODO test
        headers["Content-Type"] = "multipart/form-data"
        body = file
      else
        headers["Content-Type"] = "application/json"
        body = params.to_json
      end

      response = HTTP::Client.post "https://api.telegram.org/bot#{@token}/#{method}", headers, body

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

      #     pp {{params}}
    end

    def reply(message : Message, text : String)
      send_message(message.chat.id, text, reply_to_message_id: message.message_id)
    end

    def forward_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32)
    end

    # TODO file feltoltes
    def send_photo(chat_id : Int32 | String, photo : String, caption : String?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
    end

    # TODO file
    def send_audio(chat_id : Int32 | String, audio : String, duration = nil : Int32?, performer = nil : String?, title = nil : String?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
    end

    # TODO from file
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
