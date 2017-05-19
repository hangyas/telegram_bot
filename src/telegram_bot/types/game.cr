require "json"

module TelegramBot
  class Game
    JSON.mapping({
      title:         String,
      description:   String,
      photo:         Array(PhotoSize),
      text:          {type: String, nilable: true},
      text_entities: {type: Array(MessageEntity), nilable: true},
      animation:     {type: Animation, nilable: true},
    })
  end
end
