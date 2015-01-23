FactoryGirl.define do
  factory :feeds_message, :class => 'Feeds::Message' do
    post_id ""
sender_id ""
user_id ""
hotness 1
  end

end
