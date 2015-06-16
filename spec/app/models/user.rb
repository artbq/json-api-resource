class User < ActiveRecord::Base

  with_options presence: true do
    validates :name
    validates :age
  end
end

