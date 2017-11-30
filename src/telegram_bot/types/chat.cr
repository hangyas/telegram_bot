require "json"

module TelegramBot
  class Chat
    JSON.mapping({
      id:                             Int64,
      type:                           String,
      title:                          {type: String, nilable: true},
      username:                       {type: String, nilable: true},
      first_name:                     {type: String, nilable: true},
      last_name:                      {type: String, nilable: true},
      all_members_are_administrators: {type: Bool, nilable: true},
      photo:                          {type: ChatPhoto, nilable: true},
      description:                    {type: String, nilable: true},
      invite_link:                    {type: String, nilable: true},
      pinned_message:                 {type: Message, nilable: true},
      sticker_set_name:               {type: String, nilable: true},
      can_set_sticker_set:            {type: Bool, nilable: true},
    })
  end
end
