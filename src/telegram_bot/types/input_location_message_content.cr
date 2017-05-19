require "json"

module TelegramBot
  class InputLocationMessageContent < InputMessageContent
    FIELDS = {
      latitude:  String,
      longitude: String,
    }
    JSON.mapping({{FIELDS}})
    initializer_for({{FIELDS}})
  end
end
