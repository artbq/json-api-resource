require "active_support/all"
require "typhoeus"

module JsonApiResource
  module Get

    def all(opts={})
      r = where_with_pagination
      opts[:with_pagination] ? r : r[:entries]
    end

    def find(id)
      req = Typhoeus::Request.new("#{endpoint}/#{id}", method: :get)

      req.on_complete do |res|
        case res.code
        when 200
          return newp(JSON.parse(res.body))
        else
          return nil
        end
      end

      req.run
    end

    private

    def where_with_pagination(query={})
      req = Typhoeus::Request.new(endpoint, method: :get, params: {query: query})

      req.on_complete do |res|
        case res.code
        when 200
          r = JSON.parse(res.body).with_indifferent_access
          r[:entries].map! { |e| newp(e) }
          return r
        else
          return nil
        end
      end

      req.run
    end
  end
end

