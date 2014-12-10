module V1
  class Curriculum::StandardsController <  BaseController

    def show
      set_standard
      render json: {}, status: :not_found unless @standard
    end

    def create
      set_phase
      @standard = @phase.standards.build(standard_params)

      if @standard.save
        render :show, status: :created
      else
        render json: { error: @standard.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_standard

      if @standard.update_attributes(standard_params)
        render json: { id: @standard.id }, status: :ok
      else
        render json: {error: @standard.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_standard
      return head :not_found unless @standard

      if @standard.delete
        render json: { id: @standard.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def set_standard
      include = params[:include] rescue nil
      @standard ||= Curriculums::Standard.includes(include).find(params[:id]) rescue nil
    end

    def set_phase
      phase_id = params[:phase_id] || params[:standard][:phase_id] rescue nil
      fail 'No Phase Id' unless phase_id

      @phase ||= Curriculums::Phase.find(phase_id) rescue nil
    end

    def standard_params
      params.require(:standard).permit(:title, :phase_id)
    end
  end
end