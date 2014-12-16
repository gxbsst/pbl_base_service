module V1
  class RolesController < BaseController

    def destroy
      set_role
      return head :not_found if !@role

      if @role.destroy
        render json: { id: @role.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def configures
      {
        have_parent_resource: false,
        clazz: Role,
        clazz_resource_name: 'roles'
      }
    end

    def clazz_params
      params.fetch(:role, {}).permit!
    end

    def set_role
      include = params[:include] rescue nil
      @role ||= Role.includes(include).find(params[:id]) rescue nil
    end

  end
end