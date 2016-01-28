require "json"

module TelegramBot
  class ChoosenInlineResult
    JSON.mapping({
      result_id: String,
      from:      User,
      query:     String,
    })
  end
end
