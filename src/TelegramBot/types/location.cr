require "json"

module TelegramBot
  class Location
    JSON.mapping({
      longitude: Int32,
      latitude:  Int32,
    })
  end
end
