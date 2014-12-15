module V1
  class Pbl::RulesController < BaseController
    def index
      set_project
      page = params[:page] || 1
      @limit = params[:limit] || 10

      @rules = @project.rules.order(created_at: :desc)
      @rules = @rules.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @rules = @rules.page(page).per(@limit)
    end

    def show
      set_rule

      if !@rule
        render json: {}, status: :not_found
      end
    end

    def create
      check_project_id
      @rule = Pbls::Rule.new(rule_params)

      if @rule.save
        render :show, status: :created
      else
        render json: { error: @rule.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_rule

      if @rule.update_attributes(rule_params)
        render :show, status: :ok
      else
        render json: {error: @rule.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_rule
      return head :not_found if !@rule

      if @rule.destroy
        render json: { id: @rule.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def rule_params
      params.fetch(:rule, {}).permit!
    end

    def set_rule
      include = params[:include] rescue nil
      @rule ||= Pbls::Rule.includes(include).find(params[:id]) rescue nil
    end

    def set_project
      @project ||= Pbls::Project.find(check_project_id) rescue nil
    end

    def check_project_id
      project_id = params[:project_id] || params[:rule][:project_id] rescue nil
      fail 'No Project Id' unless project_id
      project_id
    end
  end
end