module Curriculums
  class Subject < ActiveRecord::Base
    validates :name, presence: true
    has_many :phases, class_name: 'Curriculums::Phase', dependent: :destroy
  end
end