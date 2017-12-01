require "json"

module TelegramBot
  class InputMediaPhoto < InputMedia
    JSON.mapping({
      type:    String,
      media:   String,
      caption: {type: String, nilable: true},
    })
  end
end
