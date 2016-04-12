require "json"

module TelegramBot
  class ChoosenInlineResult
    JSON.mapping({
      result_id:         String,
      from:              User,
      location:          {type: Location, nillable: true},
      inline_message_id: {type: String, nillable: true},
      query:             String,
    })
  end
end
