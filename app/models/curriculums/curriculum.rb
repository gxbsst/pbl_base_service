module Curriculums
  class Curriculum < ActiveRecord::Base
    self.table_name = 'curriculum_curriculums'

    validates :title, presence: true
    has_many :items, class_name: 'Curriculums::CurriculumItem', dependent: :destroy
    belongs_to :phase, class_name: 'Curriculums::Phase'
  end
end