module TelegramBot
  module CmdHandler
    macro included
      @commands = {} of String => (TelegramBot::Message ->) | (TelegramBot::Message, Array(String) ->)
      @cmd_handler_included = true
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
        logger.info("handle /#{cmd}")
        if proc.is_a?(Message ->)
          proc.call(message)
        else
          proc.call(message, params)
        end
      else
        raise "there is no command handler for `/#{cmd}`"
      end
    end

    private def handle_command(message : Message)
      if txt = message.text || message.caption
        if txt[0] == '/'
          a = txt.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, "").split(' ')
          cmd = a[0][1..-1]

          if cmd.includes? '@'
            parts = cmd.split('@')

            if parts[1].upcase != @name.upcase
              # not for us
              return
            end

            cmd = parts[0]
          end

          call cmd, message, a[1..-1]
          return true
        end
      end
      false
    end
  end
end
