require "./TelegramBot/*"

module TelegramBot
  def self.new(token : String)
    Bot.new(token)
  end
end
