require "json"

module TelegramBot
  class InlineQueryResultGif < InlineQueryResult
    JSON.mapping({
      type:                     String,
      id:                       String,
      gif_url:                  String,
      gif_width:                {type: Int32, nilable: true},
      gif_height:               {type: Int32, nilable: true},
      thumb_url:                String,
      title:                    {type: String, nilable: true},
      caption:                  {type: String, nilable: true},
      message_text:             {type: String, nilable: true},
      parse_mode:               {type: String, nilable: true},
      disable_web_page_preview: {type: Bool, nilable: true},
    })

    def initialize(@id : String, @gif_url : String, @thumb_url : String)
      @type = "gif"
    end
  end
end
