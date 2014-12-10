  class Curriculums::StandardItem < ActiveRecord::Base
    validates :content, presence: true
    belongs_to :standard
  end
