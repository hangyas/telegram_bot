require "json"

module TelegramBot
  class InlineQueryResultVoice < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      voice_url:             String,
      title:                 String,
      voice_duration:        {type: Int32, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: InputMessageContent,
    })

    def initialize(@id : String, @voice_url : String, @title : String, @input_message_content : InputMessageContent)
      @type = "voice"
    end
  end
end
