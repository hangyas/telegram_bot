require "json"

class PhotoSize
  JSON.mapping({
    file_id:   String,
    width:     Int32,
    height:    Int32,
    file_size: {type: Int32, nilable: true},
  })
end
