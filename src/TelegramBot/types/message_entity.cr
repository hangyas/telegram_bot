require "json"

module TelegramBot
  class MessageEntity
    FIELDS = {
      type:   String,
      offset: Int32,
      length: Int32,
      url:    {type: String, nilable: true},
      user:   {type: User, nilable: true},
    }

    JSON.mapping({{FIELDS}})
    initializer_for({{FIELDS}})
  end
end
