FactoryGirl.define do
  factory :skill_category, class: Skills::Category do
    sequence(:name) {|n| "skill-category-title-#{n}"}

    factory :skill_category_with_sub_categories do
      transient do
        sub_categories_count 5
      end

      after(:create) do |category, evaluator|
        create_list(:skill_sub_category, evaluator.sub_categories_count, category: category)
      end
    end

    factory :skill_category_with_sub_categories_and_techniques do
      transient do
        sub_categories_count 5
      end

      after(:create) do |category, evaluator|
        create_list(:skill_category_with_techniques, evaluator.sub_categories_count, category: category)
      end
    end

  end
end