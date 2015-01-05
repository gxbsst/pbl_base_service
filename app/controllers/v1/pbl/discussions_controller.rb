module V1
  class Pbl::DiscussionsController < BaseController

    def create
      CreatingPblDiscussion.create(self, params[:discussion])
    end

    def update
      set_clazz_instance

      members = params[:discussion].delete(:members)

      if @clazz_instance.update_attributes(clazz_params)

        @clazz_instance.discussion_members.destroy_all
        if members.present?
          members.each do |user_id|
            Pbls::DiscussionMember.create(user_id: user_id, discussion_id: @clazz_instance.id)
          end
        end

        render :show, status: :ok
      else
        render json: {error: @clazz_instance.errors}, status: :unprocessable_entity
      end
    end

    def on_create_success
      render json: {}, status: :created
    end

    def on_create_error(error)
      render json: {error: error}, status: :unprocessable_entity
    end

    private

    def configures
      {
        have_parent_resource: true,
        parent_resource_clazz: Pbls::Project,
        clazz: Pbls::Discussion,
        clazz_resource_name: 'discussions'
      }
    end

    def clazz_params
      params.fetch(:discussion, {}).permit!
    end

    def parent_resource_id
        params[:project_id] || params[:discussion][:project_id]
      rescue
        nil
    end

    def top_collections
      if configures[:have_parent_resource] && parent_resource_id.present?
        set_parent_resource_instance
        unless @parent_resource_instance
          return render json: {data: [], meta: {}}
        end
        @collections = @parent_resource_instance.send(:"#{configures[:clazz_resource_name]}").includes(:discussion_members).order(created_at: :desc)
      else
        @collections = configures[:clazz].includes(:discussion_members).order(created_at: :desc)
      end
    end
  end
end
