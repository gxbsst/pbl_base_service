FactoryGirl.define do
  factory :skill do
    sequence(:title) {|n| "skill-category-title-#{n}"}
  end
end