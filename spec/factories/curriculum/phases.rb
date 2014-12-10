FactoryGirl.define do
  factory :curriculum_phase, class: Curriculums::Phase do
    sequence(:name) {|n| "name-#{n}"}
    sequence(:position) {|n| n}

    association :subject, factory: :curriculum_subject

    factory :curriculum_phase_with_standards do
      transient do
        standards_count 5
      end

      after(:create) do |phase, evaluator|
        create_list(:curriculum_standard_with_items, evaluator.standards_count, phase: phase)
      end
    end

  end
end