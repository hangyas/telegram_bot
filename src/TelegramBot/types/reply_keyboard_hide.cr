require "json"

module TelegramBot
  class ReplyKeyboardHide
    # TODO toJSON
    JSON.mapping({
      hide_keyboard: Bool, # TODO must be true
      selective:     {type: Bool, nilable: true},
    })
  end

  def initialize
    @hide_keyboard = true
  end
end
