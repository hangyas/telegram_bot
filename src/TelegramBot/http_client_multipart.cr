require "http/client"

class HTTP::Client
  def self.post_multipart(url : String | URI, headers : HTTP::Headers, parts = MultipartBody) : HTTP::Client::Response
    headers["Content-Type"] = "multipart/form-data; boundary=#{parts.boundary}"
    # if !url.includes?("getUpdate")
    # r = Request.new "POST", url, headers, parts.bodyg
    # r.to_io(STDOUT)
    # end
    post url, headers, parts.bodyg
  end

  # ugly represation of multipart/from-data (works for now)
  class MultipartBody
    getter boundary

    def bodyg
      @body + "--" + @boundary + "--\r\n"
    end

    def initialize
      @boundary = Random.rand(999999).to_s + Random.rand(999999).to_s + Random.rand(999999).to_s + Random.rand(999999).to_s
      @body = ""
    end

    def add_part(name : String, content : String, mime_type = "text/plain" : String)
      @body += "--" + @boundary + "\r\n"
      @body += "Content-Disposition: form-data; name=\"#{name}\"\r\n"
      if mime_type
        @body += "Content-Type: #{mime_type}\r\n"
      end
      @body += "\r\n" + content + "\r\n"
    end

    def add_file(name : String, file : ::File, mime_type = "" : String)
      @body += "\r\n--" + @boundary + "\r\n"
      @body += "Content-Disposition: form-data; name=\"#{name}\"; filename=\"#{file.path}\"\r\n"
      if mime_type
        @body += "Content-Type: #{mime_type}\r\n"
      end

      size = file.size.to_i
      content = String.new(size) do |buffer|
        file.read Slice.new(buffer, size)
        {size.to_i, 0}
      end

      @body += "\r\n" + content + "\r\n"
    end
  end
end
