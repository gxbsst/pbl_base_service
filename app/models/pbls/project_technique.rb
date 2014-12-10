class Pbls::ProjectTechnique < ActiveRecord::Base
  belongs_to :project
  belongs_to :technique, :class_name => 'Skills::Technique'
end
