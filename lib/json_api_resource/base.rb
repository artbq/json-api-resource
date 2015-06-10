require "active_model"

require "json_api_resource/attributes"

module JsonApiResource
  class Base
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    include Attributes

    def initialize(data={})
      if data.is_a?(String)
        from_json(data)
      elsif data.is_a?(Hash)
        self.attributes = data
      else
        # TODO: throw exception
      end
    end
  end
end

