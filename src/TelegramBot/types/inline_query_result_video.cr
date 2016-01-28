require "json"

module TelegramBot
  class InlineQueryResultVideo < InlineQueryResult
    JSON.mapping({
      type:                     String,
      id:                       String,
      video_url:                String,
      mime_type:                String,
      message_text:             String,
      parse_mode:               {type: String, nilable: true},
      disable_web_page_preview: {type: Boolean, nilable: true},
      video_width:              {type: Int32, nilable: true},
      video_height:             {type: Int32, nilable: true},
      video_duration:           {type: Int32, nilable: true},
      thumb_url:                String,
      title:                    String,
      description:              {type: String, nilable: true},
    })

    def initialize(@id : String, @video_url : String, @mime_type : String, @message_text : String, @thumb_url : String, @title : String)
      @type = "video"
    end
  end
end
