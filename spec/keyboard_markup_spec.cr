require "./spec_helper"

describe TelegramBot::ReplyKeyboardMarkup do
  it "can be built with KeyboardButton objects" do
    buttons = [[
      TelegramBot::KeyboardButton.new("Button 1", request_contact: false, request_location: true),
      TelegramBot::KeyboardButton.new("Button 2", request_contact: true, request_location: false),
    ]]

    markup_json = TelegramBot::ReplyKeyboardMarkup.new(buttons).to_json

    JSON.parse(markup_json).should eq({"keyboard" => [
      [
        {"text" => "Button 1", "request_contact" => false, "request_location" => true},
        {"text" => "Button 2", "request_contact" => true, "request_location" => false},
      ],
    ]})
  end

  it "can be built with text only if other flags are unnecesary" do
    buttons = [["Button 1", "Button 2"]]

    markup_json = TelegramBot::ReplyKeyboardMarkup.new(buttons).to_json
    JSON.parse(markup_json).should eq({"keyboard" => [[{"text" => "Button 1"}, {"text" => "Button 2"}]]})
  end
end
