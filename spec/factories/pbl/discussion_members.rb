FactoryGirl.define do
  factory :pbl_discussion_member, :class => 'Pbls::DiscussionMember' do
    discussion_id ""
    role []
    association :user
  end

end
