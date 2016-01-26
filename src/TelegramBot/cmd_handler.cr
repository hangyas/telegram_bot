module TelegramBot
  module CmdHandler
    macro included
      @commands = {} of String => TelegramBot::Message ->
    end

    def /(command : String, &block : Message ->)
      @commands[command] = block
    end

    def cmd(command : String, &block : Message ->)
      @commands[command] = block
    end

    def handle(update : Update)
      txt = update.message!.text!
      if txt[0] == '/'
        #            tt = msg.text!
        cmd = txt.split(' ')[0][1..-1]

        if cmd.includes? '@'
          parts = cmd.split('@')

          if parts[1].upcase != @name.upcase
            # not for us
            return
          end

          cmd = parts[0]
        end

        pp cmd

        if proc = @commands[cmd]?
          update.message!.text = txt.split(' ')[1..-1].join(" ")
          proc.call(update.message!)
        end
      end
    rescue
      # can't handle this
    end
  end
end
