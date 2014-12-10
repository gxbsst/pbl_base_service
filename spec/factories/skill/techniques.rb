FactoryGirl.define do
  factory :skill_technique, class: Skills::Technique do
    sequence(:title) {|n| "skill-technique-title-#{n}"}
    description "description"

    association :sub_category, factory: :skill_sub_category
  end
end