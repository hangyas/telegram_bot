require "json"

module TelegramBot
  class User
    FIELDS = {
      id:         Int32,
      first_name: String,
      last_name:  {type: String, nilable: true},
      username:   {type: String, nilable: true},
    }
    JSON.mapping({{FIELDS}})
    initializer_for({{FIELDS}})
  end
end
