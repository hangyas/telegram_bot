require "json"

module TelegramBot
  class ForceReply
    JSON.mapping({
      force_reply: Bool, # TODO must be true
      selective:   {type: Bool, nilable: true},
    })

    def initialize
      @force_reply = true
    end
  end
end
