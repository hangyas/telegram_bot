require "./spec_helper"

describe TelegramBot::InlineQueryResultAudio do
  it "it's type is \"audio\"" do
    inlineQueryResultAudio = TelegramBot::InlineQueryResultAudio.new("", "", "")

    inlineQueryResultAudio.type.should eq("audio")
  end
end
