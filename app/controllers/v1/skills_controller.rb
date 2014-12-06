module V1
  class SkillsController < BaseController
    def index
      page = params[:page] || 1
      limit = params[:limit] || 10

      @skills = ::Skill.order(created_at: :desc)
      @skills = @skills.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @skills = @skills.page(page).per(limit)
    end

    def show
      set_skill
      if !@skill
        render json: {}, status: :not_found
      end
    end

    def create
      @skill = ::Skill.new(skill_params)

      if @skill.save
        render :show, status: :created
      else
        render json: { error: @skill.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_skill

      if @skill.update_attributes(skill_params)
        render json: { id: @skill.id }, status: :ok
      else
        render json: {error: @skill.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_skill
      return head :not_found if !@skill

      if @skill.delete
        render json: { id: @skill.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def skill_params
      params.require(:skill).permit(:title)
    end

    def set_skill
      include = params[:include] rescue nil
      @skill ||= ::Skill.includes(include).find(params[:id]) rescue nil
    end

  end
end