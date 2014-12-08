module V1
  class Curriculum::CurriculumsController <  BaseController

    def show
      set_curriculum
      render json: {}, status: :not_found unless @curriculum
    end

    def create
      set_phase
      @curriculum = @phase.curriculums.build(curriculum_params)

      if @curriculum.save
        render :show, status: :created
      else
        render json: { error: @curriculum.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_curriculum

      if @curriculum.update_attributes(curriculum_params)
        render json: { id: @curriculum.id }, status: :ok
      else
        render json: {error: @curriculum.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_curriculum
      return head :not_found unless @curriculum

      if @curriculum.delete
        render json: { id: @curriculum.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def set_curriculum
      include = params[:include] rescue nil
      @curriculum ||= Curriculums::Curriculum.includes(include).find(params[:id]) rescue nil
    end

    def set_phase
      phase_id = params[:phase_id] || params[:curriculum][:phase_id] rescue nil
      fail 'No Phase Id' unless phase_id

      @phase ||= Curriculums::Phase.find(phase_id) rescue nil
    end

    def curriculum_params
      params.require(:curriculum).permit(:title, :phase_id)
    end
  end
end