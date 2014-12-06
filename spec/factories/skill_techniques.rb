FactoryGirl.define do
  factory :skill_technique, class: Skills::Technique do
    sequence(:title) {|n| "skill-technique-title-#{n}"}
    description "description"
  end
end