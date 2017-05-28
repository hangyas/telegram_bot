require "json"

module TelegramBot
  class Message
    JSON.mapping({
      message_id:              Int32,
      from:                    {type: User, nilable: true},
      date:                    Int32,
      chat:                    Chat,
      forward_from:            {type: User, nilable: true},
      forward_from_chat:       {type: Chat, nilable: true},
      forward_from_message_id: {type: Int32, nilable: true},
      forward_date:            {type: Int32, nilable: true},
      reply_to_message:        {type: Message, nilable: true},
      edit_date:               {type: Int32, nilable: true},
      text:                    {type: String, nilable: true},
      entities:                {type: Array(MessageEntity), nilable: true},
      audio:                   {type: Audio, nilable: true},
      document:                {type: Document, nilable: true},
      photo:                   {type: Array(PhotoSize), nilable: true},
      sticker:                 {type: Sticker, nilable: true},
      video:                   {type: Video, nilable: true},
      voice:                   {type: Voice, nilable: true},
      video_note:              {type: VideoNote, nilable: true},
      caption:                 {type: String, nilable: true},
      contact:                 {type: Contact, nilable: true},
      location:                {type: Location, nilable: true},
      venue:                   {type: Venue, nilable: true},
      new_chat_members:        {type: Array(User), nilable: true},
      left_chat_member:        {type: User, nilable: true},
      new_chat_title:          {type: String, nilable: true},
      new_chat_photo:          {type: Array(PhotoSize), nilable: true},
      delete_chat_photo:       {type: Bool, nilable: true}, # must be true
      group_chat_created:      {type: Bool, nilable: true}, # must be true
      supergroup_chat_created: {type: Bool, nilable: true}, # must be true
      channel_chat_created:    {type: Bool, nilable: true}, # must be true
      migrate_to_chat_id:      {type: Int32, nilable: true},
      migrate_from_chat_id:    {type: Int32, nilable: true},
      pinned_message:          {type: Message, nilable: true},
      invoice:                 {type: Invoice, nilable: true},
      successful_payment:      {type: SuccessfulPayment, nilable: true},
    })
  end
end
