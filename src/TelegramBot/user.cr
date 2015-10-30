require "json"

class User
  JSON.mapping({
    id:         Int32,
    first_name: String,
    last_name:  String,
    username:   String,
  })
end
