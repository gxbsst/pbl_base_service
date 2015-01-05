class Assignments::Score < PgConnection
  belongs_to :work

  validate :check_work_state, :before => :create
  validate :update_work_state, :after => :create

  def check_work_state
   if work.state != 'submitted'
     errors[:base] << "the work has not been submitted"
   end
  end

  def update_work_state
    work.evaluate
  end
end
