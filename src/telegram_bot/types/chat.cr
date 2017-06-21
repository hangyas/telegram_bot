require "json"

module TelegramBot
  class Chat
    JSON.mapping({
      id:         Int64,
      type:       String,
      title:      {type: String, nilable: true},
      username:   {type: String, nilable: true},
      first_name: {type: String, nilable: true},
      last_name:  {type: String, nilable: true},
    })
  end
end
