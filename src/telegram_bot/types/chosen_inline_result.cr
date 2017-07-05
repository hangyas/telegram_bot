require "json"

module TelegramBot
  class ChosenInlineResult
    JSON.mapping({
      result_id:         String,
      from:              User,
      location:          {type: Location, nilable: true},
      inline_message_id: {type: String, nilable: true},
      query:             String,
    })
  end
end
