class Pbls::Task < PgConnection
  belongs_to :project
  # validates :project, presence: true
  # validates :description, presence: true

  state_machine :state, :initial => :draft do
    event :release do
      transition :draft => :released
    end
  end
end
