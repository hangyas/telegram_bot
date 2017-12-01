require "json"

module TelegramBot
  class InputMediaVideo < InputMedia
    JSON.mapping({
      type:     String,
      media:    String,
      caption:  {type: String, nilable: true},
      width:    {type: Int32, nilable: true},
      height:   {type: Int32, nilable: true},
      duration: {type: Int32, nilable: true},
    })
  end
end
