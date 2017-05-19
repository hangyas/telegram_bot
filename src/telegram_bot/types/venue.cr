require "json"

module TelegramBot
  class Venue
    JSON.mapping({
      location:      Location,
      title:         String,
      address:       String,
      foursquare_id: {type: String, nilable: true},
    })
  end
end
