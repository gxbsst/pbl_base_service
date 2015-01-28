FactoryGirl.define do
  factory :todos_todo_item, :class => 'Todos::TodoItem' do
    todo ""
user ""
state "MyString"
recipient ""
  end

end
