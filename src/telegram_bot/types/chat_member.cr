require "json"

module TelegramBot
  class ChatMember
    JSON.mapping({
      user:                      User,
      status:                    String,
      until_date:                {type: Int64, nilable: true},
      can_be_edited:             {type: Bool, nilable: true},
      can_change_info:           {type: Bool, nilable: true},
      can_post_messages:         {type: Bool, nilable: true},
      can_edit_messages:         {type: Bool, nilable: true},
      can_delete_messages:       {type: Bool, nilable: true},
      can_invite_users:          {type: Bool, nilable: true},
      can_restrict_members:      {type: Bool, nilable: true},
      can_pin_messages:          {type: Bool, nilable: true},
      can_promote_members:       {type: Bool, nilable: true},
      can_send_messages:         {type: Bool, nilable: true},
      can_send_media_messages:   {type: Bool, nilable: true},
      can_send_other_messages:   {type: Bool, nilable: true},
      can_add_web_page_previews: {type: Bool, nilable: true},
    })
  end
end
