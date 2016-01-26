require "json"

module TelegramBot
  class Update
    JSON.mapping({
      update_id: Int32,
      message:   {type: TelegramBot::Message, nilable: true},
    })

    force_getter! message
  end
end
