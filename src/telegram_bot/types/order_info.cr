require "json"

module TelegramBot
  class OrderInfo
    JSON.mapping({
      name:             {type: String, nilable: true},
      phone_number:     {type: String, nilable: true},
      email:            {type: String, nilable: true},
      shipping_address: {type: ShippingAddress, nilable: true},
    })
  end
end
