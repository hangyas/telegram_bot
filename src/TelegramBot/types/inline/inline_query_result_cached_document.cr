require "json"

module TelegramBot
  class InlineQueryResultCachedDocument < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      title:                 String,
      document_file_id:      String,
      description:           {type: String, nilable: true},
      caption:               {type: String, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String,
                   @title : String,
                   @document_file_id : String)
      @type = "document"
    end
  end
end
