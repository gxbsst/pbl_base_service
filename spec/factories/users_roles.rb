FactoryGirl.define do
  factory :users_role do
    association :user
    association :role
  end

end
