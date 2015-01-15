class Assignments::Score < PgConnection
  belongs_to :owner, polymorphic: true

  validate :check_work_state, :before => :create
  validate :update_work_state, :after => :create

  def check_work_state
    if owner_type == 'Assignments::Work' && owner.state != 'evaluating'
      errors[:base] << 'the work has not been evaluating'
    end
  end

  def update_work_state
    owner.evaluate if owner_type == 'Assignments::Work'
    self
  end
end
