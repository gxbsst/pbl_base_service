# encoding: utf-8
module V1
  class Pbl::RulesController < BaseController
    # === examples
    # ==== 获取某用户的量规
    #  /pbl/rules/?user_id=:user_id
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      if params[:user_id].present?
        project_ids = Pbls::Project.where(user_id: params[:user_id]).collect(&:id)
        @collections = @collections.where(project_id: project_ids)
      end
      @collections = @collections.page(page).per(@limit) if @collections
    end
    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Pbls::Project,
        clazz: Pbls::Rule,
        clazz_resource_name: 'rules'
      }
    end

    def clazz_params
      params.fetch(:rule, {}).permit!
    end

    def parent_resource_id
      params[:project_id] || params[:rule][:project_id]
    rescue
      nil
    end
  end
end