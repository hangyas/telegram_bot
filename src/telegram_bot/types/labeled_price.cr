require "json"

module TelegramBot
  class LabeledPrice
    JSON.mapping({
      label:  String,
      amount: Int32,
    })
  end
end
