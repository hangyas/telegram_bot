require "json"

class Voice
  JSON.mapping({
    file_id:   String,
    duration:  Int32,
    mime_type: {type: String, nilable: true},
    file_size: {type: Int32, nilable: true},
  })
end
