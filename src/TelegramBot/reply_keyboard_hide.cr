require "json"

module TelegramBot
  class ReplyKeyboardHide
    # TODO toJSON
    JSON.mapping({
      hide_keyboard: Boolean, # TODO must be true
 selective:     {type: Boolean, nilable: true},
    })
  end
end
