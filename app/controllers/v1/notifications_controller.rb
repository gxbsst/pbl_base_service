module V1
  class NotificationsController <  BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:user_id].present?
        @collections = @collections.where(user_id: params[:user_id])

        if params[:sender_type] && params[:sender_id]
          @collections = @collections.where(["sender_id = ? AND sender_type = ?", params[:sender_id], params[:sender_type]])
        end
        if params[:sender_type].present? && params[:sender_ids].present?
          sender_ids = params[:sender_ids].split(',')
          @collections = @collections.where(sender_type: params[:sender_type], sender_id: sender_ids)
        end
        if params[:sender_types].present? && params[:sender_ids].present?
          sender_ids = params[:sender_ids].split(',')
          sender_types = params[:sender_types].split(',')
          @collections = @collections.where(sender_type: sender_types, sender_id: sender_ids)
        end
      end
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    def count
      params[:read] ||= false
      count = configures[:clazz].where(read: params[:read]).count

      if params[:type].present? || params[:sender_type].present? || params[:sender_id].present? || params[:user_id].present?
        keys = %w(type sender_type sender_id user_id)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        count = configures[:clazz].where(query_hash).count
      end

      render json: {count: count}, status: 200
    end

    private
    def configures
      {
        have_parent_resource: false,
        clazz: Notification
      }
    end

    def clazz_params
      params.fetch(:notification, {}).permit!
    end
  end
end
