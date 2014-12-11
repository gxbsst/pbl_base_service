module Pbls
  class Project < ActiveRecord::Base

    acts_as_taggable

    # validates :name, presence: true

    belongs_to :user
    has_many :standard_decompositions, class_name: 'Pbls::StandardDecomposition', dependent: :destroy
    has_many :project_techniques, class_name: 'Pbls::ProjectTechnique'
    has_many :products
    # has_many :techniques, through: :project_skill_techniques
    accepts_nested_attributes_for :standard_decompositions, :project_techniques, allow_destroy: true
  end
end