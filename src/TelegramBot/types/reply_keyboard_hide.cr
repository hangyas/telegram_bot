require "json"

module TelegramBot
  class ReplyKeyboardHide
    JSON.mapping({
      hide_keyboard: Bool, # TODO must be true
      selective:     {type: Bool, nilable: true},
    })

    def initialize(@selective = nil)
      @hide_keyboard = true
    end
  end
end
