require "json"

module TelegramBot
  class ReplyKeyboardHide
    # TODO toJSON
    JSON.mapping({
      hide_keyboard: Boolean, # TODO must be true
      selective:     {type: Boolean, nilable: true},
    })
  end

  def initialize
    @hide_keyboard = true
  end
end
