require "json"

module TelegramBot
  class CallbackQuery
    JSON.mapping({
      id:                String,
      from:              User,
      message:           {type: Message, nilable: true},
      inline_message_id: {type: String, nilable: true},
      chat_instance:     String,
      data:              {type: String, nilable: true},
      game_short_name:   {type: String, nilable: true},
    })
  end
end
