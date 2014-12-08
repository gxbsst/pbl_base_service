module V1
  class Pbl::ProjectsController < BaseController

    def index
      page = params[:page] || 1
      limit = params[:limit] || 10

      @projects = Pbls::Project.order(created_at: :desc)
      @projects = @projects.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @projects = @projects.page(page).per(limit)
    end

    def show
      set_project
      if !@project
        render json: {}, status: :not_found
      end
    end

    def create
      @project= Pbls::Project.new(project_params)

      if @project.save
        render :show, status: :created
      else
        render json: { error: @project.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_project

      if @project.update_attributes(project_params)
        render json: { id: @project.id }, status: :ok
      else
        render json: {error: @project.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_project
      return head :not_found if !@project

      if @project.delete
        render json: { id: @project.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def project_params
      params.require(:project).permit(:name,
                                      :driven_issue,
                                      :stand_analysis,
                                      :duration,
                                      :limitation,
                                      :location_id,
                                      :location_id,
                                      :grade_id)
    end

    def set_project
      include = params[:include] rescue nil
      @project ||= Pbls::Project.includes(include).find(params[:id]) rescue nil
    end
  end
end