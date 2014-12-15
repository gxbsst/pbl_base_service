module V1
  class RolesController < BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      @roles = Role.order(created_at: :desc)
      @roles = @roles.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @roles = @roles.page(page).per(@limit)

      if @roles.blank?
        head :not_found
      end
    end

    def show
      set_role

      if !@role
        render json: {}, status: :not_found
      end
    end

    # === examples
    # @params
    # role: {
    #  resource_id: :project_id,
    #  resource_type: 'Project',
    #  name: 'teacher'
    # }
    #  === OR ===
    # role: [
    #   {
    #    resource_id: :project_id,
    #    resource_type: 'Project',
    #    name: 'teacher'
    #  }
    # ]
    def create

       # CreatingRole.create(params)
      if params[:role].is_a? Hash
        @role = Role.new(role_params)
      elsif params[:role].is_a? Array

      end

      if @role.save
        render :show, status: :created
      else
        render json: { error: @role.errors }, status: :unprocessable_entity
      end
    end


    def update
      set_role

      if @role.update_attributes(role_params)
        render json: { id: @role.id }, status: :ok
      else
        render json: {error: @role.errors}, status: :unprocessable_entity
      end
    end

    # @params
    #
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

    def set_role
      include = params[:include] rescue nil
      @role ||= Role.includes(include).find(params[:id]) rescue nil
    end

    def role_params
      params.fetch(:role, {}).permit!
    end
  end
end