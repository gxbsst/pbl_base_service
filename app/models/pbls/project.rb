module Pbls
  class Project < ActiveRecord::Base

    include Resourceable
    acts_as_taggable

    # validates :name, presence: true

    belongs_to :user
    belongs_to :region
    has_many :standard_decompositions, class_name: 'Pbls::StandardDecomposition', dependent: :destroy
    has_many :project_techniques, class_name: 'Pbls::ProjectTechnique'
    has_many :products
    has_many :knowledge
    has_many :tasks
    has_many :rules
    has_many :techniques
    has_many :standard_items
    # has_many :techniques, through: :project_skill_techniques
    accepts_nested_attributes_for :standard_decompositions, :project_techniques, allow_destroy: true


    state_machine :state, :initial => :draft do
      event :release do
        transition :draft => :release
      end

      event :complete do
        transition :release => :completed
      end
    end
  end
end