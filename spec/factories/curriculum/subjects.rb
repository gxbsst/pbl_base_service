FactoryGirl.define do
  factory :curriculum_subject, class: Curriculums::Subject do
    sequence(:name) {|n| "subject-name-#{n}"}

    factory :curriculum_subject_with_phases do
      transient do
        phases_count 5
      end

      after(:create) do |subject, evaluator|
        create_list(:curriculum_phase_with_standards, evaluator.phases_count, subject: subject)
      end
    end
  end
end