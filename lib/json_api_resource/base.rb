require "active_model"

require "json_api_resource/attributes"
require "json_api_resource/get"
require "json_api_resource/persistence"

module JsonApiResource
  class Base
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    include Attributes
    extend Get
    include Persistence

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

