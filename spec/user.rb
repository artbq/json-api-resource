$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "json_api_resource"

class User < JsonApiResource::Base

  def_attributes :name, :age
end

