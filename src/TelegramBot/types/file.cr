require "json"

module TelegramBot
  class File
    # TODO name conflict
    JSON.mapping({
      file_id:   String,
      file_size: {type: Int32, nilable: true},
      file_path: {type: String, nilable: true},
    })
  end
end
