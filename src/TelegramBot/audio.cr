require "json"

class Audio
  JSON.mapping({
    file_id:   String,
    duration:  Int32,
    performer: {type: String, nilable: true},
    title:     {type: String, nilable: true},
    mime_type: {type: String, nilable: true},
    file_size: {type: Int32, nilable: true},
  })
end
