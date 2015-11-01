require "json"

module TelegramBot
  class User
    JSON.mapping({
      id:         Int32,
      first_name: String,
      last_name:  {type: String, nilable: true},
      username:   {type: String, nilable: true},
    })
  end
end
