require "json"

module TelegramBot
  class InlineQueryResultArticle < InlineQueryResult
    JSON.mapping({
      type:                     String,
      id:                       String,
      title:                    String,
      message_text:             String,
      parse_mode:               {type: String, nilable: true},
      disable_web_page_preview: {type: Bool, nilable: true},
      url:                      {type: String, nilable: true},
      hide_url:                 {type: Bool, nilable: true},
      description:              {type: String, nilable: true},
      thumb_url:                {type: String, nilable: true},
      thumb_width:              {type: Int32, nilable: true},
      thumb_height:             {type: Int32, nilable: true},
    })

    def initialize(@id : String, @title : String, @message_text : String)
      @type = "article"
    end
  end
end
