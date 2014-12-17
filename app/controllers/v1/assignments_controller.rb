module V1
  class AssignmentsController < BaseController
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
      render json: {error: messages}, status: :created
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
      Role.find_by(resource_id: params[:resource_id], resource_type: params[:resource_type].capitalize, name: params[:name]).id
    rescue
      nil
    end
  end
end