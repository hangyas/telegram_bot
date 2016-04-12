require "json"

module TelegramBot
  class InlineQueryResultPhoto < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      photo_url:             String,
      thumb_url:             String,
      photo_width:           {type: Int32, nilable: true},
      photo_height:          {type: Int32, nilable: true},
      title:                 {type: String, nilable: true},
      description:           {type: String, nilable: true},
      caption:               {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @photo_url : String, @thumb_url : String)
      @type = "photo"
    end
  end
end
