module V1
  class Pbl::RulesController < BaseController

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Pbls::Project,
        clazz: Pbls::Rule,
        clazz_resource_name: 'rules'
      }
    end

    def clazz_params
      params.fetch(:rule, {}).permit!
    end

    def parent_resource_id
      params[:project_id] || params[:rule][:project_id]
    rescue
      nil
    end
  end
end