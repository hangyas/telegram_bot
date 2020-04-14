require "http/client"

module TelegramBot
  class HttpClient
    def initialize(@token : String)
    end

    def post(method : String)
      HTTP::Client.post(url_for(method))
    end

    def post_form(method : String, params : Hash)
      HTTP::Client.post(url_for(method), form: params)
    end

    def post_multipart(method : String, params)
      HTTP::Client.post_multipart(url_for(method), params)
    end

    protected def url_for(method) : String
      "https://api.telegram.org/bot#{@token}/#{method}"
    end
  end
end
