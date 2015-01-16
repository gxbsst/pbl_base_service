FactoryGirl.define do
  factory :clazz do
    name "name"


    factory :clazz_with_students do
      transient do
        students_count 5
      end

      after(:create) do |clazz, evaluator|
        create_list(:student, evaluator.students_count, clazz: clazz)
      end
    end
  end

end
