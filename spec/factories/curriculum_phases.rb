FactoryGirl.define do
  factory :curriculum_phase, class: Curriculums::Phase do
    sequence(:name) {|n| "name-#{n}"}
    sequence(:position) {|n| n}

    association :subject, factory: :curriculum_subject
    # factory :skill_category_with_technique do
    #   transient do
    #     techniques_count 5
    #   end
    #
    #   after(:create) do |category, evaluator|
    #     create_list(:skill_technique, evaluator.techniques_count, category: category)
    #   end
    # end

  end
end