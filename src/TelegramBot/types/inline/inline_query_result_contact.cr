require "json"

module TelegramBot
  class InlineQueryResultContact < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      phone_number:          String,
      first_name:            String,
      last_name:             {type: String, nilable: true},
      user_id:               {type: Int32, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
      thumb_url:             {type: String, nilable: true},
      thumb_width:           {type: Int32, nilable: true},
      thumb_height:          {type: Int32, nilable: true},
    })

    def initialize(@id : String,
                   @phone_number : String,
                   @first_name : String)
      @type = "contact"
    end
  end
end
