require "json"

module TelegramBot
  class InlineQueryResultCachedSticker < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      sticker_file_id:       String,
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @sticker_file_id : String)
      @type = "sticker"
    end
  end
end
