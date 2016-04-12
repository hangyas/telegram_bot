require "json"

module TelegramBot
  class InlineQueryResultCachedAudio < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      audio_file_id:         String,
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @audio_file_id : String)
      @type = "audio"
    end
  end
end
