require "./TelegramBot/*"

require "http/client"

module TelegramBot
  class TelegramBot
    def initialize(@token : String, @offset = 123, @timeout = 20)
      @commands = {} of String => Message ->
    end

    def /(command : String, &block : Message ->)
      @commands[command] = block
    end

    private def request(method : String, params = {} of Symbol => String | Int32 | Float)
      response = HTTP::Client.get("http://api.telegram.org/bot#{@token}/#{method}")
    end

    def get_me
      request "getMe"
    end

    def send_message(chat_id : Int32 | String, text : String, parse_mode = nil : String?, disable_web_view = nil : Boolean?, reply_to_message_id = nil : Int32?, reply_markup = nil : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil)
      request "sendMessage", {
        chat_id:             chat_id,
        parse_mode:          parse_mode,
        disable_web_view:    disable_web_view,
        reply_to_message_id: reply_to_message_id,
        reply_markup:        reply_markup,
      }

      #     pp {{params}}
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

  # TODO Put your code here
end
