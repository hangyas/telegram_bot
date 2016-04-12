require "json"

module TelegramBot
  class InlineQueryResultCachedVoice < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      voice_file_id:         String,
      title:                 String,
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: InputMessageContent,
    })

    def initialize(@id : String, @voice_file_id : String, @title : String, @input_message_content : InputMessageContent)
      @type = "voice"
    end
  end
end
