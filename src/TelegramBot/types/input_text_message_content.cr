require "json"

module TelegramBot
  class InputTextMessageContent < InputMessageContent
    JSON.mapping({
      message_text:             String,
      parse_mode:               {type: String, nilable: true},
      disable_web_page_preview: {type: Bool, nilable: true},
    })

    def initialize(@message_text : String)
    end
  end
end
