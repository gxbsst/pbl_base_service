FactoryGirl.define do
  factory :pbl_task, :class => 'Pbls::Task' do
    association :project, factory: :pbl_project
    # association :product, factory: :pbl_product

    title 'title'
    description 'description'
    teacher_tools 'teacher_tools'
    student_tools 'student_tools'
    task_type 'task_type'
    # discipline_id ''
    evaluation_duration 'evaluation_duration'
    evaluation_cycle 'evaluation_cycle'
    event_duration 'event_duration'
    event_cycle 'event_cycle'
  end

end
