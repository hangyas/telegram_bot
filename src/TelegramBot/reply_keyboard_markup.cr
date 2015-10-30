require "json"

class ReplyKeyboardMarkup
  JSON.mapping({
    keyboard:          Array(Array(String)),
    resize_keyboard:   {type: Boolean, nilable: true},
    one_time_keyboard: {type: Boolean, nilable: true},
    selective:         {type: Boolean, nilable: true},
  })
end
