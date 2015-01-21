module V1
  class FriendShipsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      top_collections

      if params[:invitee_id].present? || params[:resource_type].present? || params[:resource_id].present? || params[:user_id].present?
        keys = %w(invitee_id resource_type resource_id user_id)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash)
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    def create
      @clazz_instance = configures[:clazz].new(clazz_params)
      if @clazz_instance.save
        friend_id = params[:friend_ship].delete(:friend_id)
        user_id = params[:friend_ship].delete(:user_id)

        params[:friend_ship][:user_id] = friend_id
        params[:friend_ship][:friend_id] = user_id

        configures[:clazz].create(clazz_params)
        render :show, status: :created
      else
        render json: { error: @clazz_instance.errors }, status: :unprocessable_entity
      end

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
