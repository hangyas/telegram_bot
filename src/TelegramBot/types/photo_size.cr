require "json"

module TelegramBot
  class PhotoSize
    FIELDS = {
      file_id:   String,
      width:     Int32,
      height:    Int32,
      file_size: {type: Int32, nilable: true},
    }

    JSON.mapping({{FIELDS}})
    initializer_for({{FIELDS}})
  end
end
