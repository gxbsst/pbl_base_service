module Curriculums
  class CurriculumItem < ActiveRecord::Base
    self.table_name = 'curriculum_curriculum_items'

    validates :content, presence: true
    belongs_to :curriculum, class_name: 'Curriculums::Curriculum'
  end
end