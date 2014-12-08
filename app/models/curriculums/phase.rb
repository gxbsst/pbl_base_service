module Curriculums
  class  Phase < PgConnection
    self.table_name = 'curriculum_phases'

    belongs_to :subject, class_name: 'Curriculums::Subject'
    has_many :curriculums, dependent: :destroy
    validates :name, presence: true
  end
end