FactoryGirl.define do
  factory :post, :class => 'Groups::Post' do
    subject "subject"
    body "body"
    likes_count 0
    forwardeds_count 0

    association :user
    association :group


    factory :post_with_replies do
      transient do
        replies_count 5
      end

      after(:create) do |post, evaluator|
        create_list(:reply, evaluator.replies_count, post: post)
      end
    end
  end

end
