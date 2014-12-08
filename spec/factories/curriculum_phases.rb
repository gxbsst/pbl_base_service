FactoryGirl.define do
  factory :curriculum_phase, class: Curriculums::Phase do
    sequence(:name) {|n| "name-#{n}"}
    sequence(:position) {|n| n}

    association :subject, factory: :curriculum_subject

    factory :curriculum_phase_with_curriculums do
      transient do
        curriculums_count 5
      end

      after(:create) do |phase, evaluator|
        create_list(:curriculum_curriculum_with_items, evaluator.curriculums_count, phase: phase)
      end
    end

  end
end