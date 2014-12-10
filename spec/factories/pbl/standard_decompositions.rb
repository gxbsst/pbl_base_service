# encoding: utf-8

# 课标解读

FactoryGirl.define do
  factory :standard_decomposition, class: Pbls::StandardDecomposition do
    role 'role'
    verb 'verb'
    technique 'technique'
    noun 'noun'
    product_name 'product_name'
    association :project, factory: :pbl_project
  end
end