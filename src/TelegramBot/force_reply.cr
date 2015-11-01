require "json"

module TelegramBot
  class ForceReply
    JSON.mapping({
      force_reply: Boolean, # TODO must be true
 selective:   {type: Boolean, nilable: true},
    })

    def initialize
      @force_reply = true
    end
  end
end
