require "json"

class Document
  JSON.mapping({
    file_id:   String,
    thumb:     {type: PhotoSize, nilable: true},
    file_name: {type: String, nilable: true},
    mime_type: {type: String, nilable: true},
    file_size: {type: Int32, nilable: true},
  })
end
