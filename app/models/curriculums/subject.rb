module Curriculums
  class Subject < ActiveRecord::Base
    self.table_name = 'curriculum_subjects'

    validates :name, presence: true
    has_many :phases, class_name: 'Curriculums::Phase', dependent: :destroy
  end
end