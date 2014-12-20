module V1
  class Pbl::StandardDecompositionsController < BaseController

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Pbls::Project,
        clazz: Pbls::StandardDecomposition,
        clazz_resource_name: 'standard_decompositions'
      }
    end

    def clazz_params
      params.fetch(:standard_decomposition, {}).permit!
    end

    def parent_resource_id
      params[:project_id] || params[:standard_decomposition][:project_id]
    rescue
      nil
    end

  end
end
