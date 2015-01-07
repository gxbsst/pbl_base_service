class Assignments::Work < PgConnection

  has_many :scores, dependent: :destroy, as: :owner

  state_machine :state, :initial => :undue do
    event :do_open do
      transition :undue => :opening
    end

    event :work do
      transition [:opening, :submitted] => :working
    end

    event :submit do
      transition :working => :submitted
    end

    event :evaluate do
      transition :submitted => :evaluated
    end
  end

end
