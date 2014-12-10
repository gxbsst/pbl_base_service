FactoryGirl.define do
  factory :curriculum_item, class: Curriculums::StandardItem do
    sequence(:content) {|n| "content-#{n}"}
    association :standard, factory: :curriculum_standard
  end
end