require "http/client"
require "json"
require "logger"
require "./helper.cr"
require "./types/inline/*"
require "./types/*"

require "./http_client_multipart.cr"
require "./http_client.cr"
require "./response_client.cr"

module TelegramBot
  abstract class Bot

    @http_context : HTTP::Server::Context?

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
    def initialize(@name : String, @token : String, @whitelist : Array(String)? = nil, @blacklist : Array(String)? = nil, @updates_timeout : Int32 = nil)
      @nextoffset = 0
    end

    # run long polling in a loop and call handlers for messages
    # on the current thread!
    def polling
      loop do
        begin
          updates = get_updates
          updates.each do |u|
            handle_update(u)
          end
        rescue ex
          logger.error(ex)
        end
      end
    end

    def serve(bind_address : String = "127.0.0.1", bind_port : Int32 = 80, ssl_certificate_path : String | Nil = nil, ssl_key_path : String | Nil = nil)
      server = HTTP::Server.new(bind_address, bind_port) do |context|
        begin
          @http_context = context
          handle_update(TelegramBot::Update.from_json(context.request.body.not_nil!))
        rescue ex
          logger.error(ex)
        ensure
          @http_context = nil
        end
      end

      if ssl_certificate_path && ssl_key_path
        ssl = OpenSSL::SSL::Context.new
        ssl.certificate_chain = ssl_certificate_path.not_nil!
        ssl.private_key = ssl_key_path.not_nil!
        server.ssl = ssl
      end

      logger.info("Listening for Telegram requests in #{bind_address}:#{bind_port}#{" with ssl" if server.ssl}")
      server.listen
    end

    def handle_update(u)
      if msg = u.message
        return if !allowed_user?(msg)
        handle msg
      elsif query = u.inline_query
        return if !allowed_user?(query)
        handle query
      elsif choosen = u.choosen_inline_result
        return if !allowed_user?(choosen)
        handle choosen
      elsif callback_query = u.callback_query
        return if !allowed_user?(callback_query)
        handle callback_query
      end
    end

    protected def logger : Logger
      @logger ||= Logger.new(STDOUT).tap { |l| l.level = Logger::DEBUG }
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

    protected def request(method : String, force_http : Bool = false, params : Hash = {} of String => Object)
      client = if !force_http && (context = @http_context)
        ResponseClient.new(context.not_nil!.response)
      else
        HttpClient.new(@token)
      end

      response = if params.values.any?(&.is_a?(::IO::FileDescriptor))
        multipart_params = HTTP::Client::MultipartBody.new(params)
        client.post_multipart method, multipart_params
      elsif params.any?
        stringified_params = params.reduce(Hash(String, String).new) { |h,k,v| h[k] = v.to_s; h }
        client.post_form method, stringified_params
      else
        client.post method
      end

      return nil if response.nil?
      handle_http_response(response)
    end

    protected def handle_http_response(response)
      if response.status_code == 200
        json = JSON.parse(response.body)
        if json["ok"]
          return json["result"]
        else
          raise json["error"].as_s
        end
      else
        raise "Error #{response.status_code} in call to Telegram API: #{response.body}"
      end
    end

    def get_me
      request "getMe", force_http: true
    end

    private def get_updates(offset = @nextoffset, limit : Int32? = nil, timeout : Int32? = @updates_timeout)
      data = request("getUpdates", force_http: true, params: {"offset": "#{offset}"}).not_nil!

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
        request {{name}}, force_http: false, params: {
          {% for arg in args %}
            {{arg.stringify}} : {{arg.id}},
          {% end %}
        }
    end

    macro def_force_request(name, *args)
        request {{name}}, force_http: true, params: {
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
                     reply_markup : ReplyMarkup = nil) : Message?
      reply_markup = reply_markup.try(&.to_json)
      res = def_request "sendMessage", chat_id, text, parse_mode, disable_notification, disable_web_page_preview, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def reply(message : Message, text : String) : Message
      send_message(message.chat.id, text, reply_to_message_id: message.message_id)
    end

    def forward_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32, disable_notification : Bool? = nil) : Message?
      res = def_request "forwardMessage", chat_id, from_chat_id, message_id, disable_notification
      Message.from_json res.to_json if res
    end

    # photo file or file id
    def send_photo(chat_id : Int32 | String,
                   photo : ::File | String,
                   caption : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendPhoto", chat_id, photo, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_audio(chat_id : Int32 | String,
                   audio : ::File | String,
                   duration : Int32? = nil,
                   performer : String? = nil,
                   title : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendPhoto", chat_id, audio, duration, performer, title, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_document(chat_id : Int32 | String,
                      document : ::File | String,
                      caption : String? = nil,
                      disable_notification : Bool? = nil,
                      reply_to_message_id : Int32? = nil,
                      reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendDocument", chat_id, document, caption, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_sticker(chat_id : Int32 | String,
                     sticker : ::File | String,
                     disable_notification : Bool? = nil,
                     reply_to_message_id : Int32? = nil,
                     reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendSticker", chat_id, sticker, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_video(chat_id : Int32 | String,
                   video : ::File | String,
                   duration : Int32? = nil,
                   width : Int32? = nil,
                   height : Int32? = nil,
                   caption : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendVideo", chat_id, video, duration, width, height, disable_notification, caption, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_voice(chat_id : Int32 | String,
                   voice : ::File | String,
                   duration : Int32? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendVoice", chat_id, voice, duration, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_location(chat_id : Int32 | String,
                      latitude : Float,
                      longitude : Float,
                      disable_notification : Bool? = nil,
                      reply_to_message_id : Int32? = nil,
                      reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendLocation", chat_id, latitude, longitude, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_venue(chat_id : Int32 | String,
                   latitude : Float,
                   longitude : Float,
                   title : String,
                   address : String,
                   forsquare_id : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
                   reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendVenue", chat_id, latitude, longitude, title, address, forsquare_id, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_contact(chat_id : Int32 | String,
                     phone_number : String,
                     first_name : String,
                     last_name : String? = nil,
                     reply_to_message_id : Int32? = nil,
                     reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendContact", chat_id, phone_number, first_name, last_name, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_chat_action(chat_id : Int32 | String,
                         action : String)
      def_request "sendChatAction", chat_id, action
    end

    def get_user_profile_photos(user_id : Int32,
                                offset : Int32? = nil,
                                limit : Int32? = nil)
      res = def_force_request "getUserProfilePhotos", user_id, offset, limit
      UserProfilePhotos.from_json res.not_nil!.to_json
    end

    def kick_chat_member(chat_id : Int32 | String,
                         user_id : Int32)
      res = def_request "kickChatMember", chat_id, user_id
      res.as_bool if res
    end

    def unban_chat_member(chat_id : Int32 | String,
                          user_id : Int32)
      res = def_request "unbanChatMember", chat_id, user_id
      res.as_bool if res
    end

    def answer_callback_query(callback_query_id : String,
                              text : String? = nil,
                              show_alert : Bool? = nil)
      res = def_request "answerCallbackQuery", callback_query_id, text, show_alert
      res.as_bool if res
    end

    def edit_message_text(chat_id : Int32 | String | Nil = nil,
                          message_id : Int32? = nil,
                          inline_message_id : String = nil,
                          text : String? = nil,
                          parse_mode : String? = nil,
                          disable_web_page_preview : Bool? = nil,
                          reply_markup : InlineKeyboardMarkup? = nil) : Message?
      reply_markup = reply_markup.try(&.to_json)
      res = def_request "editMessageText", chat_id, message_id, inline_message_id, text, parse_mode, disable_web_page_preview, reply_markup
      Message.from_json res.to_json if res
    end

    def edit_message_caption(chat_id : Int32 | String | Nil = nil,
                             message_id : Int32? = nil,
                             inline_message_id : String = nil,
                             caption : String? = nil,
                             reply_markup : InlineKeyboardMarkup? = nil) : Message?
      reply_markup = reply_markup.try(&.to_json)
      res = def_request "editMessageCaption", chat_id, message_id, inline_message_id, caption, reply_markup
      Message.from_json res.to_json if res
    end

    def edit_message_reply_markup(chat_id : Int32 | String | Nil = nil,
                                  message_id : Int32? = nil,
                                  inline_message_id : String = nil,
                                  reply_markup : InlineKeyboardMarkup? = nil) : Message?
      reply_markup = reply_markup.try(&.to_json)
      res = def_request "editMessageReplyMarkup", chat_id, message_id, inline_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def answer_inline_query(inline_query_id : String,
                            results : Array(InlineQueryResult),
                            cache_time : Int32? = nil,
                            is_personal : Bool? = nil,
                            next_offset : String? = nil,
                            switch_pm_text : String? = nil,
                            switch_pm_parameter : String? = nil) : Bool?
      # results   Array of InlineQueryResult  Yes   A JSON-serialized array of results for the inline query
      results = "[" + results.join(", ") { |a| a.to_json } + "]"
      res = def_request "answerInlineQuery", inline_query_id, cache_time, is_personal, next_offset, results, switch_pm_text, switch_pm_parameter
      res.as_bool if res
    end

    def get_file(file_id : String) : File
      res = def_force_request "getFile", file_id
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

    def set_webhook(url : String, certificate : ::File | String | Nil = nil)
      multipart_params = HTTP::Client::MultipartBody.new({"url" => url})
      multipart_params.add_file("certificate", certificate, filename: "cert.pem") if certificate
      logger.info("Setting webhook to '#{url}'#{" with certificate" if certificate}")
      response = HttpClient.new(@token).post_multipart "setWebhook", multipart_params
      handle_http_response(response)
    end

  end
end
