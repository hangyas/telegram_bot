require "json"

module TelegramBot
  class UserProfilePhoto
    JSON.mapping({
      total_count: Int32,
      photos:      Array(Array(PhotoSize)),
    })
  end
end
