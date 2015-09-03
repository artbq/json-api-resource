require "active_support/all"
require "typhoeus"
require 'json_api_resource/exceptions'

module JsonApiResource

  module Get

    def all(params={}, opts={})
      r = get_list(params)
      opts[:with_pagination] ? r : r[:entries]
    end

    def where(query, opts={})
      result = get_list(query: query)
      opts[:with_pagination] ? result : result[:entries]
    end

    def find(id, params={})
      req = Typhoeus::Request.new("#{endpoint}/#{id}", method: :get, params: params)

      req.on_complete do |res|
        case res.code
        when 200
          return newp(JSON.parse(res.body))
        else
          raise JsonApiResource::BadServiceResponse
        end
      end

      req.run
    end

    private

    def get_list(params={})
      req = Typhoeus::Request.new(endpoint, method: :get, params: params)

      req.on_complete do |res|
        case res.code
        when 200
          r = JSON.parse(res.body).with_indifferent_access
          r[:entries].map! { |e| newp(e) }
          return r
        else
          raise JsonApiResource::BadServiceResponse
        end
      end

      req.run
    end
  end
end

