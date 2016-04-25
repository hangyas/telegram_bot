# TelegramBot

[Telegram Bot API](https://core.telegram.org/bots/api) wrapper for Crystal

## Current features

 - [x] all messages type
 - [x] command handler
 - [x] long polling
 - [x] inline queries
 - [x] white & black lists
 - [ ] async requests

## Usage

respond `world` to `/hello`

```crystal
require "TelegramBot"

class MyBot < TelegramBot::Bot
  include TelegramBot::CmdHandler

  def initialize
    super("MyBot", TOKEN)

    cmd "hello" do |msg|
      reply msg, "world!"
    end
  end
end

my_bot = MyBot.new
my_bot.polling
```

or you can write your own handler:

```crystal
class EchoBot < TelegramBot::Bot
  def handle(update : Update)
    msg = update.message!
    reply msg, msg.text!
  end
end
```

inline queries:

```crystal
class InlineBot < TelegramBot::Bot
  def handle(inline_query : TelegramBot::InlineQuery)
    results = Array(TelegramBot::InlineQueryResult).new
    results << TelegramBot::InlineQueryResultArticle.new(id, title, msg) 
    answer_inline_query(inline_query.id, results)
  end
end
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  TelegramBot:
    github: hangyas/TelegramBot
```


## Contributing

__Contributing is very welcomed!__

1. Fork it ( https://github.com/hangyas/TelegramBot/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [hangyas](https://github.com/hangyas) Krisztián Ádám - creator, maintainer
