FactoryGirl.define do
  factory :pbl_project, class: Pbls::Project do
    sequence(:name) {|n| "project-name-#{n}"}
    driven_issue "driven_issue"
    standard_analysis "standard_analysis"
    duration 1
    description 'description'
    state 'draft'

    trait :public  do
      limitation 5
      location_id 1
      grade_id 1
    end

    factory :pbl_project_with_tasks

    factory :pbl_project_with_standard_decompositions do
      transient do
        decompositions_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:skill, evaluator.decompositions_count, project: project)
      end
    end

    factory :pbl_project_with_skills do
      transient do
        skills_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:skill, evaluator.skills_count, project: project)
      end
    end

    factory :pbl_project_with_curriculums do
      transient do
        curriculums_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:curriculum_subject, evaluator.categories_count, project: project)
      end
    end
  end
end