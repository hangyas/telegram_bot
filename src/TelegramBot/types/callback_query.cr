require "json"

module TelegramBot
  class CallbackQuery
    JSON.mapping({
      id:                String,
      from:              User,
      message:           {type: Message, nilable: true},
      inline_message_id: {type: String, nilable: true},
      data:              String,
    })
  end
end
