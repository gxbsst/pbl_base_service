FactoryGirl.define do
  factory :follow do
    association :user
    association :follower, factory: :user
  end

end
