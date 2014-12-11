FactoryGirl.define do
  factory :pbl_product, class: Pbls::Product do
    sequence(:form) {|n| "product-form-#{n}"}
    description 'description'

    trait :final do
     is_final true
    end
  end
end