module V1
  class Assignment::WorksController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?

      if params[:task_type].present? && params[:task_id].present?
       @collections = @collections.where(task_id: params[:task_id], task_type: params[:task_type])
      end

      if params[:task_types].present? && params[:task_ids].present?
        task_types = params[:task_types].split(',')
        task_ids = params[:task_ids].split(',')

        @collections = @collections.where(task_id: task_ids, task_type: task_types)
      end

      if params[:acceptor_type].present? && params[:acceptor_id].present?
        @collections = @collections.where(acceptor_id: params[:acceptor_id], acceptor_type: params[:acceptor_type])
      end

      if params[:project_id].present?
        project = Pbls::Project.includes(:tasks).find(params[:project_id]) rescue nil

        if project
          task_ids = project.tasks.collect(&:id)
          @collections = @collections.where(task_id: task_ids)
        end
      end

      if params[:include].present?
        parse_includes
        @collections = @collections.includes(@include)
      end

      if params[:state].present?
        @collections = @collections.where(state: params[:state])
      end

      @collections = @collections.page(page).per(@limit) if @collections
    end

    def create
      CreatingAssignmentsWork.create(self, params[:work])
    end

    def update
      set_clazz_instance

      state = params[:work].delete(:state)

      if @clazz_instance.update_attributes(clazz_params)

        if state.present?
         @clazz_instance.undue if state == 'undue'
         @clazz_instance.work if state == 'working'
         @clazz_instance.do_open if state == 'opening'
         @clazz_instance.evaluate if state == 'evaluated'

         if state == 'submitted' && @clazz_instance.submit
           @clazz_instance.update_attribute(:submit_at, Time.now)
         end
        end

        render :show, status: :ok
      else
        render json: {error: @clazz_instance.errors}, status: :unprocessable_entity
      end
    end

    def on_create_success
      render json: {}, status: :created
    end

    def on_create_error(errors)
      render json: {error: errors}, status: :unprocessable_entity
    end

    private

    def configures
      {
          have_parent_resource: false,
          clazz: Assignments::Work
      }
    end

    def clazz_params
      params.fetch(:work, {}).permit!
    end

    def set_clazz_instance
      parse_includes
      @clazz_instance ||= configures[:clazz].includes(@include).find(params[:id]) rescue nil
    end

    def parse_includes
      include = params[:include] rescue nil
      if include
        @include = include.split(',')
        @include_scores = include.include? 'scores'
      end
    end

  end
end