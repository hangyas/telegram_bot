require "json"

module TelegramBot
  class ReplyKeyboardMarkup
    FIELDS = {
      keyboard:          Array(Array(String)),
      resize_keyboard:   {type: Bool, nilable: true},
      one_time_keyboard: {type: Bool, nilable: true},
      selective:         {type: Bool, nilable: true},
    }

    JSON.mapping({{FIELDS}})
    initializer_for({{FIELDS}})
  end
end
