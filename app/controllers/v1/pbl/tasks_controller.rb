module V1
  class Pbl::TasksController < BaseController

    def release
      set_clazz_instance
      if @clazz_instance.release
        render :show, status: :ok
      else
        render json: {}, status: :unprocessable_entity
      end
    end

    private

    def configures
      {
          have_parent_resource: true,
          parent_resource_clazz: Pbls::Project,
          clazz: Pbls::Task,
          clazz_resource_name: 'tasks'
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