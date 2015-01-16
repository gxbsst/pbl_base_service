module V1
  class InvitationsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:code].present?
        @collections = @collections.where(code: params[:code])
      end

      if params[:owner_type].present? && params[:owner_id].present?
        puts 'abc'
        @collections = @collections.where(owner_id: params[:owner_id], owner_type: params[:owner_type])
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    private

    def configures
      {
          have_parent_resource: false,
          clazz: Invitation
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:group, {}).permit!
    end

  end
end
