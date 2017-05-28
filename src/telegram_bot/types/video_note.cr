require "json"

module TelegramBot
  class VideoNote
    JSON.mapping({
      file_id:   String,
      length:    Int32,
      duration:  Int32,
      thumb:     {type: PhotoSize, nilable: true},
      file_size: {type: Int32, nilable: true},
    })
  end
end
