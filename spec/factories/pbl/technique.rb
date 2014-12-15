FactoryGirl.define do
 factory :pbl_technique, :class => 'Pbls::Technique' do
  association :technique, factory: :skill_technique
  association :project, factory: :pbl_project
 end

end
