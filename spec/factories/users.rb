FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"

    sequence(:username) {|n| "username-#{n}"}
    sequence(:email) { |n| "person#{Time.now.to_i}@example.com" }
    password 'secret'
  end
end