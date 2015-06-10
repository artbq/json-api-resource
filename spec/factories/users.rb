require "user"

FactoryGirl.define do
  factory :user, class: User do
    name "Deirdre Skye"
    age 600
  end
end

