FactoryGirl.define do
  factory :pbl_product, class: Pbls::Product do
    sequence(:form) {|n| "product-form-#{n}"}
    description 'description'

    association :product_form

    trait :final do
     is_final true
    end

  end
end