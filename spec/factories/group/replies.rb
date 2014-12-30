FactoryGirl.define do
  factory :reply, :class => 'Groups::Reply' do
    body "body"
    association :user
  end

end
