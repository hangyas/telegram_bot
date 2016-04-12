require "json"

module TelegramBot
  class InputVenueMessageContent < InputMessageContent
    JSON.mapping({
      latitude:     Float64,
      longitude:    Float64,
      title:        String,
      address:      String,
      forsquare_id: String,
    })
  end
end
