FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"

    sequence(:email) { |n| "person#{n}@example.com" }
    password 'secret'
  end
end