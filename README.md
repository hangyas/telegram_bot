# TelegramBot

Crystal library for Telegram Bot API

## Current features (not so much)

 - text messages
 - command handler
 - only long polling supported (webhook planned)
 - all media messages handled without the file

## Usage


```crystal
class MyBot < TelegramBot::Bot
  include TelegramBot::CmdHandler

  def initialize
    super("MyBot", TOKEN)

    cmd "hello" do |msg|
      reply msg, "world!"
    end
  end
end

my_bot = MyBot.new.polling
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

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  TelegramBot:
    github: hangyas/TelegramBot
```


## Contributing

__A lot of features is missing so contributing is very welcomed!__

1. Fork it ( https://github.com/hangyas/TelegramBot/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [hangyas](https://github.com/hangyas) Krisztián Ádám - creator, maintainer
