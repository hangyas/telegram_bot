require "json"

module TelegramBot
  class ReplyKeyboardHide
    FIELDS = {
      hide_keyboard: {type: Bool, mustbe: true},
      selective:     {type: Bool, nilable: true},
    }

    JSON.mapping({{FIELDS}})
    initializer_for({{FIELDS}})
  end
end
