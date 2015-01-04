module V1
  class Pbl::WorksController < BaseController

    private
    def configures
      {
          have_parent_resource: true,
          parent_resource_clazz: Pbls::Task,
          clazz: Pbls::Work,
          clazz_resource_name: 'works'
      }
    end

    def clazz_params
      params.fetch(:task, {}).permit!
    end

    def parent_resource_id
      params[:project_id] || params[:task][:project_id]
    rescue
      nil
    end
  end
end
