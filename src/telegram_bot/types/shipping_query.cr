require "json"

module TelegramBot
  class ShippingQuery
    JSON.mapping({
      id:               String,
      from:             User,
      invoice_payload:  String,
      shipping_address: ShippingAddress,
    })
  end
end
