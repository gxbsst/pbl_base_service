FactoryGirl.define do
  factory :skill do
    sequence(:title) {|n| "skill-category-title-#{n}"}

    factory :skill_with_categories do
      transient do
        categories_count 5
      end

      after(:create) do |skill, evaluator|
        create_list(:skill_category, evaluator.categories_count, skill: skill)
      end
    end

    factory :skill_with_categories_and_techniques do
      transient do
        categories_count 5
      end

      after(:create) do |skill, evaluator|
        create_list(:skill_category_with_techniques, evaluator.categories_count, skill: skill)
      end
    end

  end
end