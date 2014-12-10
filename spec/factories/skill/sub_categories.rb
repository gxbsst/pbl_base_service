FactoryGirl.define do
  factory :skill_sub_category, class: Skills::SubCategory do
    sequence(:name) {|n| "skill-category-name-#{n}"}
    sequence(:position) {|n| n}
    association :category, factory: :skill_category

    factory :skill_sub_category_with_technique do
      transient do
        techniques_count 5
      end

      after(:create) do |sub_category, evaluator|
        create_list(:skill_technique, evaluator.techniques_count, sub_category: sub_category)
      end
    end

  end
end