require "json"

module TelegramBot
  class InlineQueryResultMpeg4Gif < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      mpeg4_url:             String,
      mpeg4_width:           {type: Int32, nilable: true},
      mpeg4_height:          {type: Int32, nilable: true},
      thumb_url:             String,
      title:                 {type: String, nilable: true},
      caption:               {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @mpeg4_url : String, @thumb_url : String)
      @type = "mpeg4_gif"
    end
  end
end
