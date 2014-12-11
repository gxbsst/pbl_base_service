FactoryGirl.define do
  factory :gauge do
    level_1 "level_1"
    level_2 "level_2"
    level_3 "level_3"
    level_4 "level_4"
    level_5 "level_5"
    level_6 "level_6"
    level_7 "level_7"

    association :technique, factory: :skill_technique
  end
end