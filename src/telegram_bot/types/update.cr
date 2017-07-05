require "json"

module TelegramBot
  class Update
    JSON.mapping({
      update_id:            Int32,
      message:              {type: TelegramBot::Message, nilable: true},
      edited_message:       {type: TelegramBot::Message, nilable: true},
      channel_post:         {type: TelegramBot::Message, nilable: true},
      edited_channel_post:  {type: TelegramBot::Message, nilable: true},
      inline_query:         {type: TelegramBot::InlineQuery, nilable: true},
      chosen_inline_result: {type: TelegramBot::ChosenInlineResult, nilable: true},
      callback_query:       {type: TelegramBot::CallbackQuery, nilable: true},
      shipping_query:       {type: TelegramBot::ShippingQuery, nilable: true},
      pre_checkout_query:   {type: TelegramBot::PreCheckoutQuery, nilable: true},
    })
  end
end
