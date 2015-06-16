$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "json_api_resource"

class User < JsonApiResource::Base

  def_attributes :id, :name, :age

  validates_presence_of :age

  private

  def self.endpoint
    "http://localhost:3000/users"
  end
end

