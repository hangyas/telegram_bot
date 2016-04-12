require "json"

module TelegramBot
  class InlineQueryResultVideo < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      video_url:             String,
      mime_type:             String,
      thumb_url:             String,
      title:                 String,
      caption:               {type: String, nilable: true},
      video_width:           {type: Int32, nilable: true},
      video_height:          {type: Int32, nilable: true},
      video_duration:        {type: Int32, nilable: true},
      description:           {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @video_url : String,
                   @mime_type : String,
                   @thumb_url : String,
                   @title : String,
                   @caption : String? = nil,
                   @video_width : Int32? = nil,
                   @video_height : Int32? = nil,
                   @video_duration : Int32? = nil,
                   @description : String? = nil,
                   @reply_markup : InlineKeyboardMarkup = nil,
                   @input_message_content : InputMessageContent? = nil)
      @type = "video"
    end
  end
end
