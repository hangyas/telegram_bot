require "json"
require "./input_message_content.cr"

module TelegramBot
  class InputContactMessageContent < InputMessageContent
    JSON.mapping({
      phone_number: String,
      first_name:   String,
      last_name:    {type: String, nillable: true},
    })
  end
end
