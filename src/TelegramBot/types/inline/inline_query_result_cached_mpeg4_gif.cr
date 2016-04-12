require "json"

module TelegramBot
  class InlineQueryResultCachedMpeg4Gif < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      mpeg4_file_id:         String,
      title:                 {type: String, nilable: true},
      caption:               {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @mpeg4_file_id : String)
      @type = "mpeg4_gif"
    end
  end
end
