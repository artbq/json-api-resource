require "typhoeus"

module JsonApiResource
  module Request

    def send_request(path, method, params)
      req = Typhoeus::Request.new("#{endpoint}/#{path}", method: method, params: params)
      req.on_complete do |res|
        yield(JSON.parse(res.body))
      end
      req.run
    end
  end
end

