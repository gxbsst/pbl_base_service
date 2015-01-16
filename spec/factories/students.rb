FactoryGirl.define do
  factory :student do
    role []
    association :user
  end

end
