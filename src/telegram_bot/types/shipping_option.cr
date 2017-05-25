require "json"

module TelegramBot
  class ShippingOption
    JSON.mapping({
      id:     String,
      title:  String,
      prices: Array(LabeledPrice),
    })
  end
end
