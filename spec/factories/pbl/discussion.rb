FactoryGirl.define do
  factory :pbl_discussion, class: 'Pbls::Discussion' do
    name "name"
    no 1

    association :project, factory: :pbl_project

    factory :pbl_discussion_with_members do
      transient do
        members_count 5
      end

      after(:create) do |discussion, evaluator|
        create_list(:pbl_discussion_member, evaluator.members_count, discussion: discussion)
      end
    end
  end
end
