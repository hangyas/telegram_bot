require "json"

module TelegramBot
  class Update
    JSON.mapping({
      update_id:             Int32,
      message:               {type: TelegramBot::Message, nilable: true},
      inline_query:          {type: TelegramBot::InlineQuery, nilable: true},
      choosen_inline_result: {type: TelegramBot::ChoosenInlineResult, nilable: true},
    })

    force_getter! message, inline_query, choosen_inline_result
  end
end
