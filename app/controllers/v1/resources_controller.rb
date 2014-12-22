# encoding: utf-8
module V1
  class ResourcesController < BaseController

    # === examples
    # ====  获取某个owner的resources
    #  "/resources/:owner_type/:owner_id"

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      @collections = Resource.order(created_at: :desc)
      @collections = @collections.where(["owner_id = ? AND owner_type = ?", params[:owner_id], params[:owner_type]]) if params[:owner_type] && params[:owner_id]
      if params[:owner_type].present? && params[:owner_ids].present?
        owner_ids = params[:owner_ids].split(',')
        @collections = @collections.where(owner_type: params[:owner_type], owner_id: owner_ids)
      end
      if params[:owner_types].present? && params[:owner_ids].present?
        owner_ids = params[:owner_ids].split(',')
        owner_types = params[:owner_types].split(',')
        @collections = @collections.where(owner_type: owner_types, owner_id: owner_ids)
      end
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit)
    end

    private

    def configures
      {
        have_parent_resource: true,
        clazz: Resource,
        clazz_resource_name: 'resources'
      }
    end

    def clazz_params
      params.fetch(:resource, {}).permit!
    end

    def parent_resource_id
      params[:owner_id] || params[:resource][:owner_id]
    rescue
      nil
    end

    def set_parent_resource_instance
      params[:owner_type].constantize.find(check_parent_resource_id) rescue nil
    end
  end
end