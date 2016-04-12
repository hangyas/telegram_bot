require "json"

module TelegramBot
  class InlineQueryResultLocation < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      latitude:              Float64,
      longitude:             Float64,
      title:                 String,
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
      thumb_url:             {type: String, nilable: true},
      thumb_width:           {type: Int32, nilable: true},
      thumb_height:          {type: Int32, nilable: true},
    })

    def initialize(@id : String,
                   @latitude : String,
                   @longitude : String,
                   @title : String)
      @type = "location"
    end
  end
end
