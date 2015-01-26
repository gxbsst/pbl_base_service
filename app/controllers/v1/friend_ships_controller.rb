module V1
  class FriendShipsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:user_id].present? || params[:friend_id].present? || params[:relation].present?
        keys = %w(user_id friend_id relation)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash)
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    def create
       CreatingFriendShip.create(self, params[:friend_ship])
    end

    def on_create_success
      render json: {}, status: :created
    end

    def on_create_error(errors)
      render json: {error: errors}, status: :unprocessable_entity
    end

    private

    def top_collections
      @collections = configures[:clazz].order(created_at: :desc)
    end

    def configures
      {
          have_parent_resource: false,
          clazz: FriendShip
      }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:friend_ship, {}).permit!
    end
  end
end
