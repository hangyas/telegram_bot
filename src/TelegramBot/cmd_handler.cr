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
        if txt = message.text || message.caption
          message.text = txt.split(' ')[1..-1].join(" ")
          proc.call(message)
        end
      end
    end

    def handle(message : Message) : Bool
      if txt = message.text || message.caption
        if txt[0] == '/'
          cmd = txt.split(' ')[0][1..-1]

          if cmd.includes? '@'
            parts = cmd.split('@')

            if parts[1].upcase != @name.upcase
              # not for us
              return false
            end

            cmd = parts[0]
          end

          pp cmd

          call cmd, message
          return true
        else
          return false
        end
      else
        puts message.to_json
        return false
      end
    rescue e
      puts "ERROR"
      pp e.message
      # can't handle this
      return false
    end
  end
end
