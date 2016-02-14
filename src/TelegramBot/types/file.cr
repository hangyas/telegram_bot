require "json"

module TelegramBot
  class File
    JSON.mapping({
      file_id:   String,
      file_size: {type: Int32, nilable: true},
      file_path: {type: String, nilable: true},
    })

    force_getter! file_size, file_path
  end
end
