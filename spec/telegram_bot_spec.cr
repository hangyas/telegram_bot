require "./spec_helper"

class TestBot < TelegramBot::Bot
  include TelegramBot::CmdHandler

  def initialize
    super "testbot", ""

    cmd "example" do |msg, params|
      send_message msg.chat.id, "test"
    end
  end
end

describe TelegramBot do
  it "works" do
    test = TestBot.new
  end
end
