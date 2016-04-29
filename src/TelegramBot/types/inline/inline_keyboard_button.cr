require "json"

module TelegramBot
  class InlineKeyboardButton
    JSON.mapping({
      text:                String,
      url:                 {type: String, nilable: true},
      callback_data:       {type: String, nilable: true},
      switch_inline_query: {type: String, nilable: true},
    })

    def initialize(@text : String, @url : String? = nil, @callback_data : String? = nil, switch_inline_query : String? = nil)
    end
  end
end
