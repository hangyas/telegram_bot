require "json"

module TelegramBot
  class InlineQueryResultCachedGif < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      gif_file_id:           String,
      title:                 {type: String, nilable: true},
      caption:               {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @gif_file_id : String)
      @type = "gif"
    end
  end
end
