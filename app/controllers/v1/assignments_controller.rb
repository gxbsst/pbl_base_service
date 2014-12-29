module V1
  class AssignmentsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      if params[:resource_id].present? &&  params[:resource_type].present? && params[:name].present?
        @collections = @collections.where(role_id: parent_resource_id)
      end
      @collections = @collections.page(page).per(@limit) if @collections
    end

    # === examples
    # @params
    # users_role: {
    #  resource_id: :project_id,
    #  resource_type: 'Project',
    #  name: 'teacher'
    # }
    #  === OR ===
    # users_role: [
    #   {
    #    id: users_role_id
    #    resource_id: :project_id,
    #    resource_type: 'Project',
    #    name: 'teacher'
    #    user_id: user.id,
    #    _destroy: true
    #  }
    # ]
    def create
      CreatingAssignment.create(self, params[:assignment])
    end

    def destroy
      if params[:ids].present?
        ids = params[:ids].split(',')
        if UsersRole.where(id: ids).destroy_all
          render json: { id: ids }, status: :ok
        else
          head :unauthorized
        end
      end

      if params[:id].present?
        if UsersRole.find(params[:id]).destroy
          render json: { id: params[:id] }, status: :ok
        else
          head :unauthorized
        end
      end
    end

    def create_on_success(messages)
      render json: {}, status: :created
    end

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Role,
        clazz: UsersRole,
        clazz_resource_name: 'assignments'
      }
    end

    def clazz_params
      params.fetch(:assignment, {}).permit!
    end

    def parent_resource_id
      Role.find_by(resource_id: params[:resource_id], resource_type: params[:resource_type], name: params[:name]).id
    rescue
      nil
    end
  end
end