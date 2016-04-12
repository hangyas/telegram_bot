require "json"

module TelegramBot
  class InlineQueryResultCachedPhoto < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      photo_file_id:         String,
      title:                 {type: String, nilable: true},
      description:           {type: String, nilable: true},
      caption:               {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @photo_file_id : String)
      @type = "photo"
    end
  end
end
