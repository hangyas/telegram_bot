require "json"

module TelegramBot
  class PreCheckoutQuery
    JSON.mapping({
      id:                 String,
      from:               User,
      currency:           String,
      total_amount:       Int32,
      invoice_payload:    String,
      shipping_option_id: {type: String, nilable: true},
      order_info:         {type: OrderInfo, nilable: true},
    })
  end
end
