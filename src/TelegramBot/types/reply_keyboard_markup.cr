require "json"

module TelegramBot
  class ReplyKeyboardMarkup
    JSON.mapping({
      keyboard:          Array(Array(String)),
      resize_keyboard:   {type: Bool, nilable: true},
      one_time_keyboard: {type: Bool, nilable: true},
      selective:         {type: Bool, nilable: true},
    })
  end
end
