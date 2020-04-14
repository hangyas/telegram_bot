module TelegramBot
  class ResponseClient
    def initialize(@response : HTTP::Server::Response)
    end

    def post(method : String)
      post_form(method, {} of String => String)
    end

    def post_form(method : String, params : Hash(String, String))
      body = HTTP::Params.build do |form_builder|
        params.each { |key, value| form_builder.add key, value }
        form_builder.add "method", method
      end

      @response.content_type = "application/x-www-form-urlencoded"
      @response.print(body)
      @response.close
      nil
    end

    def post_multipart(method : String, multipart_body : HTTP::Client::MultipartBody)
      multipart_body.add_part("method", method)
      @response.content_type = "multipart/form-data; boundary=#{multipart_body.boundary}"
      @response.print(multipart_body.bodyg)
      @response.close
      nil
    end
  end
end
