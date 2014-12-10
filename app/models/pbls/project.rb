module Pbls
  class Project < ActiveRecord::Base
    self.table_name = 'pbl_projects'

    acts_as_taggable

    validates :name, presence: true

    has_many :standard_decompositions, class_name: 'Pbls::StandardDecomposition', dependent: :destroy

    accepts_nested_attributes_for :standard_decompositions, allow_destroy: true
  end
end