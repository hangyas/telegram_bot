require "json"

class Update
  JSON.mapping({
    update_id: Int32,
    message:   {type: Message, nilable: true},
  })
end
