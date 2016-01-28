require "json"

module TelegramBot
  class InlineQuery
    JSON.mapping({
      id:     String,
      from:   User,
      query:  String,
      offset: String,
    })
  end
end
