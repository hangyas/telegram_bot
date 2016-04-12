require "json"

module TelegramBot
  class InlineQueryResultVenue < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      latitude:              Float64,
      longitude:             Float64,
      title:                 String,
      address:               String,
      foursquare_id:         {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
      thumb_url:             {type: String, nilable: true},
      thumb_width:           {type: Int32, nilable: true},
      thumb_height:          {type: Int32, nilable: true},
    })

    def initialize(@id : String,
                   @latitude : Float,
                   @longitude : Float,
                   @title : String,
                   @address : String)
      @type = "venue"
    end
  end
end
