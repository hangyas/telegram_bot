require "json"

module TelegramBot
  class Message
    JSON.mapping({
      message_id:            Int32,
      from:                  User,
      date:                  Int32,
      chat:                  Chat,
      forward_from:          {type: User, nilable: true},
      forward_date:          {type: Int32, nilable: true},
      forward_to_message:    {type: Message, nilable: true},
      text:                  {type: String, nilable: true},
      audio:                 {type: Audio, nilable: true},
      document:              {type: Document, nilable: true},
      photo:                 {type: Array(PhotoSize), nilable: true},
      sticker:               {type: Sticker, nilable: true},
      video:                 {type: Video, nilable: true},
      voice:                 {type: Voice, nilable: true},
      caption:               {type: String, nilable: true},
      contact:               {type: Contact, nilable: true},
      location:              {type: Location, nilable: true},
      new_chat_participant:  {type: User, nilable: true},
      left_chat_participant: {type: User, nilable: true},
      new_chat_title:        {type: String, nilable: true},
      new_chat_photo:        {type: Array(PhotoSize), nilable: true},
      delete_chat_photo:     {type: Bool, nilable: true}, # must be true
 group_chat_created:    {type: Bool, nilable: true}       # must be true
    })
  end
end
