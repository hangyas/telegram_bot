require "json"

class Video
  JSON.mapping({
    file_id:   String,
    width:     Int32,
    height:    Int32,
    duration:  Int32,
    thumb:     {type: PhotoSize, nilable: true},
    mime_type: {type: String, nilable: true},
    file_size: {type: Int32, nilable: true},
  })
end
