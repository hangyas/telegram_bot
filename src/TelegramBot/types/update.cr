require "json"

module TelegramBot
  class Update
    JSON.mapping({
      update_id:             Int32,
      message:               {type: TelegramBot::Message, nilable: true},
      inline_query:          {type: TelegramBot::InlineQuery, nilable: true},
      choosen_inline_result: {type: TelegramBot::ChoosenInlineResult, nilable: true},
      callback_query:        {type: TelegramBot::CallbackQuery, nilable: true},
    })

    force_getter! message, inline_query, choosen_inline_result, callback_query
  end
end
