$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "factory_girl"
require "typhoeus"

RSpec.configure do |c|
  c.include FactoryGirl::Syntax::Methods
  c.before(:all) do
    FactoryGirl.reload
  end
end

def clean_db
  Typhoeus::Request.new("http://localhost:3000/users", method: :delete).run
end

