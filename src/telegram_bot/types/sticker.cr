require "json"

module TelegramBot
  class Sticker
    JSON.mapping({
      file_id:       String,
      width:         Int32,
      height:        Int32,
      thumb:         {type: PhotoSize, nilable: true},
      emoji:         {type: String, nilable: true},
      set_name:      {type: String, nilable: true},
      mask_position: {type: MaskPosition, nilable: true},
      file_size:     {type: Int32, nilable: true},
    })
  end
end
