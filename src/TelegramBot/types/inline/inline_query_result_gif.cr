require "json"

module TelegramBot
  class InlineQueryResultGif < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      gif_url:               String,
      gif_width:             {type: Int32, nilable: true},
      gif_height:            {type: Int32, nilable: true},
      thumb_url:             String,
      title:                 {type: String, nilable: true},
      caption:               {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @gif_url : String, @thumb_url : String)
      @type = "gif"
    end
  end
end
