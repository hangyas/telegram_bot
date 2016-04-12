require "json"

module TelegramBot
  class InlineQueryResultAudio < InlineQueryResult
    JSON.mapping({
      type:                  String,
      id:                    String,
      audio_url:             String,
      title:                 String,
      performer:             {type: String, nilable: true},
      audio_duration:        {type: Int32, nilable: true},
      reply_markup:          {type: InlineKeyboardMarkup, nilable: true},
      input_message_content: {type: InputMessageContent, nilable: true},
    })

    def initialize(@id : String, @audio_url : String, @title : String)
      @type = "audio"
    end
  end
end
