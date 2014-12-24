FactoryGirl.define do
  factory :member_ship, class: Groups::MemberShip do
    association :member, factory: :user
    association :group
    state ''
    role ''
  end

end
