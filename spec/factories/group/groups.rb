FactoryGirl.define do
  factory :group, class: Groups::Group do
    name "name"
    description "description"
    owner_type "OwnerType"
    # owner_id

    factory :group_with_members do
      transient do
        members_count 5
      end

      after(:create) do |group, evaluator|
        create_list(:member_ship, evaluator.members_count, group: group)
      end
    end

  end

end
