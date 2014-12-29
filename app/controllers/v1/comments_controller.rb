module V1
  class CommentsController < BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      @collections = Comment.order(created_at: :desc)
      if params[:commentable_type] && params[:commentable_id]
        @collections = @collections.where(["commentable_id = ? AND commentable_type = ?", params[:commentable_id], params[:commentable_type]])
      end
      if params[:commentable_type].present? && params[:commentable_ids].present?
        commentable_ids = params[:commentable_ids].split(',')
        @collections = @collections.where(commentable_type: params[:commentable_type], commentable_id: commentable_ids)
      end
      if params[:commentable_types].present? && params[:commentable_ids].present?
        commentable_ids = params[:commentable_ids].split(',')
        commentable_types = params[:commentable_types].split(',')
        @collections = @collections.where(commentable_type: commentable_types, commentable_id: commentable_ids)
      end
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit)
    end

    private

    def configures
      {
        have_parent_resource: false,
        clazz: Comment
      }
    end

    def clazz_params
      params.fetch(:comment, {}).permit!
    end

  end
end
