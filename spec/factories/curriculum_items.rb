FactoryGirl.define do
  factory :curriculum_item, class: Curriculums::CurriculumItem do
    sequence(:content) {|n| "content-#{n}"}
    association :curriculum, factory: :curriculum_curriculum
  end
end