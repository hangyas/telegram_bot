require "http/client"

class HTTP::Client
  def self.post_multipart(url : String | URI, parts : MultipartBody, headers : HTTP::Headers | Nil = nil) : HTTP::Client::Response
    headers ||= HTTP::Headers.new
    headers["Content-Type"] = "multipart/form-data; boundary=#{parts.boundary}"
    post url, headers, parts.bodyg
  end

  def self.post_multipart(url : String | URI, params : Hash, headers : HTTP::Headers | Nil = nil) : HTTP::Client::Response
    parts = HTTP::Client::MultipartBody.new
    params.each do |k, v|
      if v.nil?
        next
      elsif v.is_a?(::File)
        parts.add_file(k, v)
      else
        parts.add_part(k, v.to_s)
      end
    end
    post_multipart(url, parts, headers)
  end

  # ugly represation of multipart/from-data (works for now)
  class MultipartBody
    getter boundary

    @boundary : String

    def bodyg
      @body + "--" + @boundary + "--\r\n"
    end

    def initialize
      @boundary = Random.rand(999999).to_s + Random.rand(999999).to_s + Random.rand(999999).to_s + Random.rand(999999).to_s
      @body = ""
    end

    def add_part(name : String, content : String, mime_type : String = "text/plain")
      @body += "--" + @boundary + "\r\n"
      @body += "Content-Disposition: form-data; name=\"#{name}\"\r\n"
      if mime_type
        @body += "Content-Type: #{mime_type}\r\n"
      end
      @body += "\r\n" + content + "\r\n"
    end

    def add_file(name : String, file : ::File, mime_type : String = "application/octet-stream")
      @body += "--" + @boundary + "\r\n"
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
