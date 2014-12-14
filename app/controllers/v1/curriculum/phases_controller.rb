module V1
  class Curriculum::PhasesController <  BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      @phases = Curriculums::Phase.order(created_at: :desc)
      @phases = @phases.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @phases = @phases.where(subject_id: params[:subject_id]) if params[:subject_id].present?
      @phases = @phases.page(page).per(@limit)
      if @phases.blank?
        head :not_found
      end
    end

    def show
      set_phase
      render json: {}, status: :not_found unless @phase
    end

    def create
      set_subject
      @phase = @subject.phases.build(phase_params)

      if @phase.save
        render :show, status: :created
      else
        render json: { error: @phase.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_phase

      if @phase.update_attributes(phase_params)
        render json: { id: @phase.id }, status: :ok
      else
        render json: {error: @phase.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_phase
      return head :not_found unless @phase

      if @phase.delete
        render json: { id: @phase.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def set_phase
      include = params[:include] rescue nil
      @phase ||= Curriculums::Phase.includes(include).find(params[:id]) rescue nil
    end

    def set_subject
      subject_id = params[:subject_id] || params[:phase][:subject_id] rescue nil
      fail 'No Subject Id' unless subject_id

      @subject ||= ::Curriculums::Subject.find(subject_id) rescue nil
    end

    def phase_params
      params.require(:phase).permit(:name, :curriculum_id)
    end
  end
end