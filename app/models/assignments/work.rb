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

    event :evaluating do
      transition :submitted => :evaluating
    end
    event :evaluate do
      transition :evaluating => :evaluated
    end

    event :undue do
      transition all => :undue
    end

  end

end
