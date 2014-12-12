module V1
  class Pbl::ProjectsController < BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      @projects = Pbls::Project.order(created_at: :desc)
      @projects = @projects.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @projects = @projects.page(page).per(@limit)
    end

    def show
      set_project
      if !@project
        render json: {}, status: :not_found
      end
    end

    # @param [Hash]
    #  params = {
    #   project: {
    #     name: 'name',
    #    standard_decompositions_attributes:  [{role: 'role', verb: 'verb'}]  # array
    #   }
    #  }
    #
    def create
      @project= Pbls::Project.new(project_params)

      if @project.save
        render :show, status: :created
      else
        render json: { error: @project.errors }, status: :unprocessable_entity
      end
    end

    # @param [Hash]
    #  params = {
    #   project: {
    #     name: 'name',
    #    standard_decompositions_attributes:  [{ id: 'id', role: 'role', verb: 'verb', _destroy: true}]  # array
    #   }
    #  }
    #

    def update
      set_project

      if @project.update_attributes(project_params)
        render :show, status: :ok
      else
        render json: {error: @project.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_project
      return head :not_found if !@project

      if @project.destroy
        render json: { id: @project.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def project_params
      params.fetch(:project, {}).permit!
      # (:name,
      #                                 :driven_issue,
      #                                 :standard_analysis,
      #                                 :duration,
      #                                 :limitation,
      #                                 :location_id,
      #                                 :location_id,
      #                                 :grade_id,
      #                                 :description,
      #                                 standard_decompositions_attributes: [:id, :role, :verb, :technique, :noun, :product_name, :_destroy])
    end

    def set_project
      include = params[:include] rescue nil
      @project ||= Pbls::Project.includes(include).find(params[:id]) rescue nil
    end
  end
end