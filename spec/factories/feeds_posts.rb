FactoryGirl.define do
  factory :feeds_post, :class => 'Feeds::Post' do
    title "MyString"
content "MyText"
like_count 1
blocked false
owner_type "MyString"
owner_id ""
user_id ""
sender_id ""
resource_id ""
  end

end
