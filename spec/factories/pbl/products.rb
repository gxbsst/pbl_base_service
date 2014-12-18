FactoryGirl.define do
  factory :pbl_product, class: Pbls::Product do
    description 'description'

    association :product_form
    association :project, factory: :pbl_project

    trait :final do
     is_final true
    end

  end
end