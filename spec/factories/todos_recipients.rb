FactoryGirl.define do
  factory :todos_recipient, :class => 'Todos::Recipient' do
    todo_id ""
assignee_id ""
assignee_type "MyString"
  end

end
