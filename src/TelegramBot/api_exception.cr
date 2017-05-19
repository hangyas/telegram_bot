require "json"

module TelegramBot
  class APIException < Exception
    @data : JSON::Any?
    @code : Int32

    getter code, data

    def initialize(@code, @data)
    end

    def message
      "Error #@code in call to Telegram API : #@data"
    end
  end
end
