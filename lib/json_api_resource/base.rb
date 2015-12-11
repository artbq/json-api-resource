require "active_model"

require "json_api_resource/attributes"
require "json_api_resource/get"
require "json_api_resource/persistence"
require "json_api_resource/request"

require 'active_support/configurable'

module JsonApiResource
  class Base
    class Configuration
      attr_accessor(
        :get_list_request_options,
        :find_request_options,
      )

      def initialize
        @get_list_request_options = {}
        @find_request_options = {}
      end
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def configuration
      self.class.configuration
    end

    def self.configure
      yield configuration
    end

    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    include Attributes
    extend Get
    include Persistence
    extend Request

    def initialize(data={})
      if data.is_a?(String)
        from_json(data)
      elsif data.is_a?(Hash)
        self.attributes = data
      else
        # TODO: Raise exception
      end
    end

    private

    def self.endpoint
      raise NotImplementedError
    end

    def endpoint
      self.class.endpoint
    end
  end
end

