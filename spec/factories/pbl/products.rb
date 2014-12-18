FactoryGirl.define do
  factory :pbl_product, class: Pbls::Product do
    description 'description'

    association :product_form
    association :project, factory: :pbl_project

    trait :final do
     is_final true
    end

    factory :pbl_product_with_resources do
      transient do
        resources_count 5
      end

      after(:create) do |product, evaluator|
        create_list(:resource, evaluator.resources_count, owner_type: 'project_product', owner_id: product.id)
      end
    end
  end
end