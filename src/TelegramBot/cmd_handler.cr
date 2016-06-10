module TelegramBot
  module CmdHandler
    macro included
      @commands = {} of String => (TelegramBot::Message ->) | (TelegramBot::Message, Array(String) ->)
    end

    def /(command : String, &block : Message ->)
      @commands[command] = block
    end

    def /(command : String, &block : Message, Array(String) ->)
      @commands[command] = block
    end

    def cmd(command : String, &block : Message ->)
      @commands[command] = block
    end

    def cmd(command : String, &block : Message, Array(String) ->)
      @commands[command] = block
    end

    def call(cmd : String, message : Message, params : Array(String))
      if proc = @commands[cmd]?
        if txt = message.text || message.caption
          if proc.is_a?(Message ->)
            proc.call(message)
          else
            proc.call(message, params)
          end
        end
      end
    end

    def handle(message : Message) : Bool
      if txt = message.text || message.caption
        if txt[0] == '/'
          a = txt.split(' ')
          cmd = a[0][1..-1]

          if cmd.includes? '@'
            parts = cmd.split('@')

            if parts[1].upcase != @name.upcase
              # not for us
              return false
            end

            cmd = parts[0]
          end

          logger.info(cmd)
          call cmd, message, a[1..-1]
          return true
        else
          return false
        end
      else
        puts message.to_json
        return false
      end
    rescue e
      logger.error(e)
      # can't handle this
      return false
    end
  end
end
