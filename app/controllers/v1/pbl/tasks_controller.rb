module V1
  class Pbl::TasksController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?

      if params[:state].present?
        @collections = @collections.where(state: params[:state])
      end

      @collections = @collections.page(page).per(@limit) if @collections
    end

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