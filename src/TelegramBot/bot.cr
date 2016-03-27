require "http/client"
require "json"
require "./helper.cr"
require "./types/*"

require "./http_client_multipart.cr"

module TelegramBot
  abstract class Bot
    # handle messages
    # return: true if the message is handled successfully
    #         this can be useful for overwrited handlers
    def handle(message : Message) : Bool
      return false
    end

    # handle inline query
    def handle(inline_query : InlineQuery)
    end

    # handle choosen inlien query
    def handle(inline_query : ChoosenInlineResult)
    end

    # @name name of the bot (not rely used yet)
    # @token
    # @private_mode if true the bot will handle request sent by users from @users
    # @users list of users for private mode
    def initialize(@name : String, @token : String, @private_mode : Bool = false, @users = [] of String)
      @nextoffset = 0
    end

    # run long polling in a loop and call handlers for messages
    # on the current thread!
    def polling
      loop do
        begin
          updates = get_updates
          updates.each do |u|
            if msg = u.message
              if @private_mode && !@users.includes? msg.from!.username!
                next
              end
              handle msg
              if msg.text
                p msg.text
              end
            elsif query = u.inline_query
              if @private_mode && !@users.includes? query.from.username!
                next
              end
              handle query
            elsif choosen = u.choosen_inline_result
              if @private_mode && !@users.includes? choosen.from.username!
                next
              end
              handle choosen
            end
          end
        rescue ex
          pp ex
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

    private def get_updates(offset = @nextoffset, limit : Int32? = nil, timeout : Int32? = nil)
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

    def send_message(chat_id : Int32 | String, text : String, parse_mode : String? = nil, disable_web_page_preview : Bool? = nil, reply_to_message_id : Int32? = nil, reply_markup : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil = nil) : Message
      if reply_markup
        reply_markup = reply_markup.to_json
      end
      res = def_request "sendMessage", chat_id, text, parse_mode, disable_web_page_preview, reply_to_message_id, reply_markup
      # puts res.to_json
      Message.from_json res.to_json
    end

    def reply(message : Message, text : String) : Message
      send_message(message.chat.id, text, reply_to_message_id: message.message_id)
    end

    def forward_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32)
      res = def_request "forwardMessage", chat_id, from_chat_id, message_id
      Message.from_json res.to_json
    end

    # photo file or file id
    def send_photo(chat_id : Int32 | String, photo : ::File | String, caption : String? = nil, reply_to_message_id : Int32? = nil, reply_markup : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil = nil)
      res = def_request "sendPhoto", chat_id, photo, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_audio(chat_id : Int32 | String, audio : ::File | String, duration : Int32? = nil, performer : String? = nil, title : String? = nil, reply_to_message_id : Int32? = nil, reply_markup : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil = nil)
      res = def_request "sendPhoto", chat_id, audio, duration, performer, title, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_document(chat_id : Int32 | String, document : ::File | String, reply_to_message_id : Int32? = nil, reply_markup : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil = nil)
      res = def_request "sendDocument", chat_id, document, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_sticker(chat_id : Int32 | String, sticker : ::File | String, reply_to_message_id : Int32? = nil, reply_markup : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil = nil)
      res = def_request "sendSticker", chat_id, sticker, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_video(chat_id : Int32 | String, video : ::File | String, duration : Int32? = nil, caption : String? = nil, reply_to_message_id : Int32? = nil, reply_markup : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil = nil)
      res = def_request "sendVideo", chat_id, video, duration, caption, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_voice(chat_id : Int32 | String, voice : ::File | String, duration : Int32? = nil, reply_to_message_id : Int32? = nil, reply_markup : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil = nil)
      res = def_request "sendVoice", chat_id, voice, duration, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_location(chat_id : Int32 | String, latitude : Float, longitude : Float, reply_to_message_id : Int32? = nil, reply_markup : ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil = nil)
      res = def_request "sendLocation", chat_id, latitude, longitude, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def answer_inline_query(inline_query_id : String, result_array : Array(InlineQueryResult), cache_time : Int32? = nil, is_personal : Bool? = nil, next_offset : String? = nil) : Bool
      # results   Array of InlineQueryResult  Yes   A JSON-serialized array of results for the inline query
      results = "[" + result_array.join(", ") { |a| a.to_json } + "]"
      res = def_request "answerInlineQuery", inline_query_id, cache_time, is_personal, next_offset, results

      return res.as_bool
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
