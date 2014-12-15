module V1
  class Pbl::TechniquesController < BaseController

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Pbls::Project,
        clazz: Pbls::Technique,
        clazz_resource_name: 'techniques'
      }
    end

    def clazz_params
      params.fetch(:technique, {}).permit!
    end

    def parent_resource_id
      params[:project_id] || params[:technique][:project_id]
    rescue
      nil
    end
  end
end