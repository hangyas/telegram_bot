require "json"

module TelegramBot
  class InlineQueryResultPhoto < InlineQueryResult
    JSON.mapping({
      type:                     String,
      id:                       String,
      photo_url:                String,
      photo_width:              {type: Int32, nilable: true},
      photo_height:             {type: Int32, nilable: true},
      thumb_url:                String,
      title:                    {type: String, nilable: true},
      description:              {type: String, nilable: true},
      caption:                  {type: String, nilable: true},
      message_text:             {type: String, nilable: true},
      parse_mode:               {type: String, nilable: true},
      disable_web_page_preview: {type: Boolean, nilable: true},
    })

    def initialize(@id : String, @photo_url : String, @thumb_url : String)
      @type = "photo"
    end
  end
end
