FactoryGirl.define do
  factory :skill_category, class: Skills::Category do
    sequence(:name) {|n| "skill-category-name-#{n}"}
    sequence(:position) {|n| n}
    skill

    factory :skill_category_with_technique do
      transient do
        techniques_count 5
      end

      after(:create) do |category, evaluator|
        create_list(:skill_technique, evaluator.techniques_count, category: category)
      end
    end

  end
end