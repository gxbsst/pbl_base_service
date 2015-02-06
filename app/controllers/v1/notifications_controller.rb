module V1
  class NotificationsController <  BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections

      if params[:user_id].present? && params[:sender_id].present? && params[:type].present?
        @collections = @collections.where(["type = '%s' AND ((user_id = '%s' AND sender_id = '%s') OR (sender_id = '%s' AND user_id = '%s'))", params[:type], params[:user_id], params[:sender_id], params[:user_id], params[:sender_id]])
      else
        if params[:type].present? || params[:user_id].present? || params[:sender_id].present? || params[:sender_type].present? || params[:event_type].present?
          keys = %w(type sender_type sender_id user_id event_type)
          query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
          @collections = @collections.where(query_hash)
        end
      end

      if params[:older_id].present?
        notification = Notification.find(params[:older_id])
        @collections = @collections.where(["created_at < ?", notification.created_at])
      end

      if params[:latest_id].present?
        notification = Notification.find(params[:latest_id])
        @collections = @collections.where(["created_at > ?", notification.created_at])
      end

      if params[:sender_ids].present?
        sender_ids = params[:sender_ids].split(',')
        @collections = @collections.where(sender_id: sender_ids)
      end
      if params[:sender_types].present?
        sender_types = params[:sender_types].split(',')
        @collections = @collections.where(sender_type: sender_types)
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    def count
      params[:read] ||= false
      @collections =  configures[:clazz].where(read: params[:read])

      if params[:type].present? || params[:sender_type].present? || params[:sender_id].present? || params[:user_id].present? || params[:event_type].present?
        keys = %w(type sender_type sender_id user_id event_type)
        query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}
        @collections = @collections.where(query_hash)
      end

      if params[:sender_ids].present?
        sender_ids = params[:sender_ids].split(',')
        @collections = @collections.where(sender_id: sender_ids)
      end

      if params[:sender_types].present?
        sender_types = params[:sender_types].split(',')
        @collections = @collections.where(sender_type: sender_types)
      end

      render json: {count: @collections.count}, status: 200
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
