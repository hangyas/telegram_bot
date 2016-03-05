require "json"

module TelegramBot
  class ReplyKeyboardMarkup
    JSON.mapping({
      keyboard:          Array(Array(String)),
      resize_keyboard:   {type: Bool, nilable: true},
      one_time_keyboard: {type: Bool, nilable: true},
      selective:         {type: Bool, nilable: true},
    })

    def initialize(@keyboard)
    end
  end
end
