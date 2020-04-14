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

  it "logs messages" do
    IO.pipe do |r, w|
      test = TestBot.new
      TestBot::Log.level = :debug
      TestBot::Log.backend = ::Log::IOBackend.new(w)

      spawn { test.polling }
      Fiber.yield
      test.stop

      r.gets.should match(/TestBot is ready to lead/)
      r.gets.should match(/TestBot is going to take a rest/)
    end
  end
end
