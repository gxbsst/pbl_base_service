FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"

    sequence(:username) {|n| "username-#{n}#{Time.now.to_i}"}
    sequence(:email) { |n| "person-#{n}#{Time.now.to_i}@example.com" }
    password 'secret'
    avatar 'avatar'
    type 'Teacher'
    realname 'realname'
    nickname 'nickname'
    disciplines []
    interests []
  end
end