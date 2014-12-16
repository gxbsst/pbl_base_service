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
  end
end