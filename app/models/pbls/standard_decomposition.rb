module Pbls
  class StandardDecomposition < PgConnection
    self.table_name = 'pbl_standard_decompositions'
    belongs_to :project, class_name: 'Pbls::Project'
    # attr_accessor :_destory
  end
end