require "json"

class Chat
  JSON.mapping({
    id:         Int32,
    _type:      String,
    title:      String,
    username:   String,
    first_name: String,
    last_name:  String,
  })
end
