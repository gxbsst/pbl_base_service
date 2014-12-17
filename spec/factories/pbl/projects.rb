FactoryGirl.define do
  factory :pbl_project, class: Pbls::Project do
    sequence(:name) {|n| "project-name-#{n}"}
    driven_issue "driven_issue"
    standard_analysis "standard_analysis"
    duration 1
    description 'description'
    rule_head 'rule_head'
    rule_template 'rule_template'
    # state 'draft
    association :user, factory: :user#, email: "#{Time.now.to_i}@gmail.com"

    trait :public  do
      limitation 5
      location_id 1
      grade_id 1
    end


    factory :pbl_project_with_standard_decompositions do
      transient do
        decompositions_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:standard_decomposition, evaluator.decompositions_count, project: project)
      end
    end

    factory :pbl_project_with_techniques do
      transient do
        techniques_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:pbl_technique, evaluator.techniques_count, project: project)
      end
    end

    factory :pbl_project_with_rules do
      transient do
        rules_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:pbl_rule, evaluator.rules_count, project: project)
      end
    end

    factory :pbl_project_with_standard_items do
      transient do
        standard_items_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:pbl_standard_item, evaluator.standard_items_count, project: project)
      end
    end

    factory :pbl_project_with_standard_items_and_techniques do
      transient do
        standard_items_and_techniques_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:pbl_standard_item, evaluator.standard_items_and_techniques_count, project: project)
      end

      after(:create) do |project, evaluator|
        create_list(:pbl_technique, evaluator.standard_items_and_techniques_count, project: project)
      end
    end

    factory :pbl_project_with_knowledge do
      transient do
        knowledge_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:pbl_knowledge, evaluator.knowledge_count, project: project)
      end
    end

    factory :pbl_project_with_tasks do
      transient do
        tasks_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:pbl_task, evaluator.tasks_count, project: project)
      end
    end
  end
end