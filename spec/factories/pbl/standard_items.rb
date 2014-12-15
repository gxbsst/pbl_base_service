FactoryGirl.define do
 factory :pbl_standard_item, :class => 'Pbls::StandardItem' do
  association :standard_item, factory: :curriculum_item
  association :project, factory: :pbl_project
 end

end
