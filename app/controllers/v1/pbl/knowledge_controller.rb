module V1
  class Pbl::KnowledgeController < BaseController

    private

    def configures
      {
          have_parent_resource: true,
          parent_resource_clazz: Pbls::Project,
          clazz: Pbls::Knowledge,
          clazz_resource_name: 'knowledge'
      }
    end

    def clazz_params
      params.fetch(:knowledge, {}).permit!
    end

    def parent_resource_id
      params[:project_id] || params[:knowledge][:project_id]
    rescue
      nil
    end
  end
end