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

    def call(cmd : String, message : Message)
      if proc = @commands[cmd]?
        if txt = message.text
          message.text = txt.split(' ')[1..-1].join(" ")
          proc.call(message)
        end
      end
    end

    def handle(message : Message)
      txt = message.text!
      if txt[0] == '/'
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

        call cmd, message
      end
    rescue e
      puts "ERROR"
      pp e.message
      # can't handle this
    end
  end
end
