FactoryGirl.define do
  factory :curriculum_curriculum, class: Curriculums::Curriculum do
    sequence(:title) {|n| "curriculum-title-#{n}"}

    association :phase, factory: :curriculum_phase

    factory :curriculum_curriculum_with_items do
      transient do
        curriculum_items_count 5
      end

      after(:create) do |curriculum, evaluator|
        create_list(:curriculum_item, evaluator.curriculum_items_count, curriculum: curriculum)
      end
    end
  end
end