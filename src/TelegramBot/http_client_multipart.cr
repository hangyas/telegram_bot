require "http/client"
require "tempfile"

class HTTP::Client
  def self.post_multipart(url : String | URI, parts : MultipartBody | Hash, headers : HTTP::Headers | Nil = nil) : HTTP::Client::Response
    exec(url) do |client, path|
      client.post_multipart(path, parts, headers)
    end
  end

  def post_multipart(path, parts : MultipartBody, headers : HTTP::Headers | Nil = nil) : HTTP::Client::Response
    headers ||= HTTP::Headers.new
    headers["Content-Type"] = "multipart/form-data; boundary=#{parts.boundary}"
    post path, headers, parts.bodyg
  end

  def post_multipart(path, params : Hash, headers : HTTP::Headers | Nil = nil) : HTTP::Client::Response
    parts = HTTP::Client::MultipartBody.new(params)
    post_multipart(path, parts, headers)
  end

  # ugly represation of multipart/from-data (works for now)
  class MultipartBody
    getter boundary

    @boundary : String = Random.rand(999999).to_s + Random.rand(999999).to_s + Random.rand(999999).to_s + Random.rand(999999).to_s
    @body : String = ""

    def bodyg
      @body + "--" + @boundary + "--\r\n"
    end

    def initialize
    end

    def initialize(params : Hash)
      params.each do |k, v|
        if v.nil?
          next
        elsif v.is_a?(::File)
          add_file(k, v)
        else
          add_part(k, v.to_s)
        end
      end
    end

    def add_part(name : String, content : String, mime_type : String = nil)
      @body += "--" + @boundary + "\r\n"
      @body += "Content-Disposition: form-data; name=\"#{name}\"\r\n"
      if mime_type
        @body += "Content-Type: #{mime_type}\r\n"
      end
      @body += "\r\n" + content + "\r\n"
    end

    def add_file(name : String, content : String, filename : String? = nil, mime_type : String = "application/octet-stream")
      @body += "--" + @boundary + "\r\n"
      @body += "Content-Disposition: form-data; name=\"#{name}\"; filename=\"#{filename}\"\r\n"
      if mime_type
        @body += "Content-Type: #{mime_type}\r\n"
      end

      @body += "\r\n" + content + "\r\n"
    end

    def add_file(name : String, file : ::File | ::Tempfile, filename : String? = nil, mime_type : String = "application/octet-stream")
      content = File.read(file.path)
      add_file(name, content, filename || file.path, mime_type)
    end
  end
end
