require "json"

class Contact
  JSON.mapping({
    phone_number: String,
    first_name:   String,
    last_name:    {type: String, nilable: true},
    user_id:      {type: Int32, nilable: true},
  })
end
