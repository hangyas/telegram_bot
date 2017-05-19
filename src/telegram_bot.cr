require "./telegram_bot/*"

module TelegramBot
  def self.new(token : String)
    Bot.new(token)
  end
end
