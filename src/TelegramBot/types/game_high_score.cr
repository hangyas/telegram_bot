require "json"

module TelegramBot
  class GameHighScore
    JSON.mapping({
      position: Int32,
      user:     User,
      score:    Int32,
    })
  end
end
