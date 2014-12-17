FactoryGirl.define do
  factory :role do

    factory :user_with_assignments do
      transient do
        assignments_count 5
      end

      after(:create) do |role, evaluator|
        create_list(:users_role, evaluator.assignments_count, role: role)
      end
    end
  end
end
