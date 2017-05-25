require "json"

module TelegramBot
  class SuccessfulPayment
    JSON.mapping({
      currency:                   String,
      total_amount:               Int32,
      invoice_payload:            String,
      shipping_option_id:         {type: String, nilable: true},
      order_info:                 {type: OrderInfo, nilable: true},
      telegram_payment_charge_id: String,
      provider_payment_charge_id: String,
    })
  end
end
