FactoryGirl.define do
  factory :pbl_work, :class => 'Pbls::Work' do
    association :task, factory: :pbl_task
    association :assignee, factory: :user
    owner_type ''
    owner_id ''
  end

end
