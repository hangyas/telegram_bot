require "./spec_helper"

describe TelegramBot::InlineQueryResultArticle do
  it "it's type is \"article\"" do
    inputTextMessageContent = TelegramBot::InputTextMessageContent.new(message_text: "text")
    inlineQueryResultArticle = TelegramBot::InlineQueryResultArticle.new(id: "id", title: "title", input_message_content: inputTextMessageContent)

    inlineQueryResultArticle.type.should eq("article")
  end
end
