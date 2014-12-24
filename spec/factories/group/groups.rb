FactoryGirl.define do
  factory :group, class: Groups::Group do
    name "name"
    description "description"
    association :user
  end

end
