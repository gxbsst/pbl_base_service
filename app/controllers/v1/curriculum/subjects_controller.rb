module V1
  class Curriculum::SubjectsController < BaseController
    def index
      page = params[:page] || 1
      limit = params[:limit] || 10

      @subjects = Curriculums::Subject.order(created_at: :desc)
      @subjects = @subjects.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @subjectss = @subjects.page(page).per(limit)
    end

    def show
      set_subject
      render json: {}, status: :not_found unless @subject
    end

    def create
      @subject = Curriculums::Subject.new(subject_params)

      if @subject.save
        render :show, status: :created
      else
        render json: { error: @subject.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_subject

      if @subject.update_attributes(subject_params)
        render json: { id: @subject.id }, status: :ok
      else
        render json: {error: @subject.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_subject
      return head :not_found unless @subject

      if @subject.delete
        render json: { id: @subject.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def subject_params
      params.require(:subject).permit(:name)
    end

    def set_subject
      include = params[:include] rescue nil
      @subject ||= Curriculums::Subject.includes(include).find(params[:id]) rescue nil
    end
  end
end