require "http/server"
require "http/client"

class Server
  def initalize(@port = 8080)
    @listener = HTTP::Server.new(@port) do |request|
                  HTTP::Response.ok "text/plain", "Hello world!"
                end
    server.listen
  end
end
