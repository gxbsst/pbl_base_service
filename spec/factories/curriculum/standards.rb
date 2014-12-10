FactoryGirl.define do
  factory :curriculum_standard, class: Curriculums::Standard do
    sequence(:title) {|n| "curriculum-title-#{n}"}

    association :phase, factory: :curriculum_phase

    factory :curriculum_standard_with_items do
      transient do
        curriculum_items_count 5
      end

      after(:create) do |standard, evaluator|
        create_list(:curriculum_item, evaluator.curriculum_items_count, standard: standard)
      end
    end
  end
end