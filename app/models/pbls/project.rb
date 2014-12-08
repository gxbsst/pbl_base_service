module Pbls
  class Project < ActiveRecord::Base
    self.table_name = 'pbl_projects'

    acts_as_taggable

  end
end