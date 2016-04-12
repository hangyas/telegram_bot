require "json"

module TelegramBot
  class InlineKeyboardMarkup
    JSON.mapping({
      inline_keyboard: Array(Array(InlineKeyboardButton)),
    })
  end
end
