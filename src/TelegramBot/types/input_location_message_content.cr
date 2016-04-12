require "json"

module TelegramBot
  class InputLocationMessageContent < InputMessageContent
    JSON.mapping({
      latitude:  String,
      longitude: String,
    })
  end
end
