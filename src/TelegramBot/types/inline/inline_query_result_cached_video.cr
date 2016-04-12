require "json"

module TelegramBot
  class InlineQueryResultCachedVideo < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      video_file_id:         String,
      title:                 String,
      caption:               {type: String, nilable: true},
      description:           {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String,
                   @video_file_id : String,
                   @title : String)
      @type = "video"
    end
  end
end
