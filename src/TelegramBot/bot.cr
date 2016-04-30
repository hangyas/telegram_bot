require "http/client"
require "json"
require "./helper.cr"
require "./types/inline/*"
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

    # handle callback query
    def handle(callback_query : CallbackQuery)
    end

    # @name name of the bot (not rely used yet)
    # @token
    # @whitelist
    # @blacklist
    # @users list of users for private mode
    def initialize(@name : String, @token : String, @whitelist : Array(String)? = nil, @blacklist : Array(String)? = nil)
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
              next if !allowed_user?(msg)
              handle msg
            elsif query = u.inline_query
              next if !allowed_user?(query)
              handle query
            elsif choosen = u.choosen_inline_result
              next if !allowed_user?(choosen)
              handle choosen
            elsif callback_query = u.callback_query
              next if !allowed_user?(callback_query)
              handle callback_query
            end
          end
        rescue ex
          pp ex
        end
      end
    end

    private def allowed_user?(msg) : Bool
      if msg.is_a?(Message)
        if msg.from.is_a?(User)
          from = msg.from!
        else
          return @whitelist.is_a?(Nil)
        end
      else
        from = msg.from
      end

      if blacklist = @blacklist
        begin
          # on the blacklist
          return !blacklist.includes?(from.username!)
        rescue
          # doesn't have username at all
          return true
        end
      end

      if whitelist = @whitelist
        begin
          # not on the whitelist
          return whitelist.includes?(from.username!)
        rescue
          # doesn't have username at all
          return false
        end
      end
      return true
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

    alias ReplyMarkup = InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardHide | ForceReply | Nil

    def send_message(chat_id : Int32 | String,
                     text : String,
                     parse_mode : String? = nil,
                     disable_web_page_preview : Bool? = nil,
                     disable_notification : Bool? = nil,
                     reply_to_message_id : Int32? = nil,
                     reply_markup : ReplyMarkup = nil) : Message
      if reply_markup
        reply_markup = reply_markup.to_json
      end
      res = def_request "sendMessage", chat_id, text, parse_mode, disable_notification, disable_web_page_preview, reply_to_message_id, reply_markup
      # puts res.to_json
      Message.from_json res.to_json
    end

    def reply(message : Message, text : String) : Message
      send_message(message.chat.id, text, reply_to_message_id: message.message_id)
    end

    def forward_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32, disable_notification : Bool? = nil)
      res = def_request "forwardMessage", chat_id, from_chat_id, message_id, disable_notification
      Message.from_json res.to_json
    end

    # photo file or file id
    def send_photo(chat_id : Int32 | String,
                   photo : ::File | String,
                   caption : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil)
      res = def_request "sendPhoto", chat_id, photo, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_audio(chat_id : Int32 | String,
                   audio : ::File | String,
                   duration : Int32? = nil,
                   performer : String? = nil,
                   title : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil)
      res = def_request "sendPhoto", chat_id, audio, duration, performer, title, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_document(chat_id : Int32 | String,
                      document : ::File | String,
                      caption : String? = nil,
                      disable_notification : Bool? = nil,
                      reply_to_message_id : Int32? = nil,
                      reply_markup : ReplyMarkup = nil)
      res = def_request "sendDocument", chat_id, document, caption, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_sticker(chat_id : Int32 | String,
                     sticker : ::File | String,
                     disable_notification : Bool? = nil,
                     reply_to_message_id : Int32? = nil,
                     reply_markup : ReplyMarkup = nil)
      res = def_request "sendSticker", chat_id, sticker, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_video(chat_id : Int32 | String,
                   video : ::File | String,
                   duration : Int32? = nil,
                   width : Int32? = nil,
                   height : Int32? = nil,
                   caption : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil)
      res = def_request "sendVideo", chat_id, video, duration, width, height, disable_notification, caption, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_voice(chat_id : Int32 | String,
                   voice : ::File | String,
                   duration : Int32? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil)
      res = def_request "sendVoice", chat_id, voice, duration, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_location(chat_id : Int32 | String,
                      latitude : Float,
                      longitude : Float,
                      disable_notification : Bool? = nil,
                      reply_to_message_id : Int32? = nil,
                      reply_markup : ReplyMarkup = nil)
      res = def_request "sendLocation", chat_id, latitude, longitude, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_venue(chat_id : Int32 | String,
                   latitude : Float,
                   longitude : Float,
                   title : String,
                   address : String,
                   forsquare_id : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil)
      res = def_request "sendVenue", chat_id, latitude, longitude, title, address, forsquare_id, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_contact(chat_id : Int32 | String,
                     phone_number : String,
                     first_name : String,
                     last_name : String? = nil,
                     reply_to_message_id : Int32? = nil,
                     reply_markup : ReplyMarkup = nil)
      res = def_request "sendContact", chat_id, phone_number, first_name, last_name, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json
    end

    def send_chat_action(chat_id : Int32 | String,
                         action : String)
      res = def_request "sendChatAction", chat_id, action
    end

    def get_user_profile_photos(user_id : Int32,
                                offset : Int32? = nil,
                                limit : Int32? = nil)
      res = def_request "getUserProfilePhotos", user_id, offset, limit
      UserProfilePhotos.from_json res.to_json
    end

    def kick_chat_member(chat_id : Int32 | String,
                         user_id : Int32)
      res = def_request "kickChatMember", chat_id, user_id
      res.as_bool
    end

    def unban_chat_member(chat_id : Int32 | String,
                          user_id : Int32)
      res = def_request "unbanChatMember", chat_id, user_id
      res.as_bool
    end

    def answer_callback_query(callback_query_id : String,
                              text : String? = nil,
                              show_alert : Bool? = nil)
      res = def_request "answerCallbackQuery", callback_query_id, text, show_alert
      res.as_bool
    end

    def edit_message_text(chat_id : Int32 | String | Nil = nil,
                          message_id : Int32? = nil,
                          inline_message_id : String = nil,
                          text : String? = nil,
                          parse_mode : String? = nil,
                          disable_web_page_preview : Bool? = nil,
                          reply_markup : InlineKeyboardMarkup? = nil)
      reply_markup = reply_markup.to_json
      res = def_request "editMessageText", chat_id, message_id, inline_message_id, text, parse_mode, disable_web_page_preview, reply_markup
      Message.from_json res.to_json
    end

    def edit_message_caption(chat_id : Int32 | String | Nil = nil,
                             message_id : Int32? = nil,
                             inline_message_id : String = nil,
                             caption : String? = nil,
                             reply_markup : InlineKeyboardMarkup? = nil)
      reply_markup = reply_markup.to_json
      res = def_request "editMessageCaption", chat_id, message_id, inline_message_id, caption, reply_markup
      Message.from_json res.to_json
    end

    def edit_message_reply_markup(chat_id : Int32 | String | Nil = nil,
                                  message_id : Int32? = nil,
                                  inline_message_id : String = nil,
                                  reply_markup : InlineKeyboardMarkup? = nil)
      reply_markup = reply_markup.to_json
      res = def_request "editMessageReplyMarkup", chat_id, message_id, inline_message_id, reply_markup
      Message.from_json res.to_json
    end

    def answer_inline_query(inline_query_id : String,
                            results : Array(InlineQueryResult),
                            cache_time : Int32? = nil,
                            is_personal : Bool? = nil,
                            next_offset : String? = nil,
                            switch_pm_text : String? = nil,
                            switch_pm_parameter : Strin? = nil) : Bool
      # results   Array of InlineQueryResult  Yes   A JSON-serialized array of results for the inline query
      results = "[" + results.join(", ") { |a| a.to_json } + "]"
      res = def_request "answerInlineQuery", inline_query_id, cache_time, is_personal, next_offset, results, switch_pm_text, switch_pm_parameter

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
