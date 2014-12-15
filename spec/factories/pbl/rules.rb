FactoryGirl.define do
 factory :pbl_rule, :class => 'Pbls::Rule' do
  level_1 "level_1"
  level_2 "level_2"
  level_3 "level_3"
  level_4 "level_4"
  level_5 "level_5"
  level_6 "level_6"
  level_7 "level_7"
  weight "weight"
  standard "standard"

  association :technique, factory: :skill_technique
  association :project, factory: :pbl_project
  association :gauge
 end

end
