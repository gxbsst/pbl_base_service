module V1
  class Pbl::ProjectsController < BaseController

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections
      if params[:user_id].present?
       @collections = @collections.where(user_id: params[:user_id])
      end

      if params[:name].present?
        @collections = @collections.where(["name LIKE ?",  "%#{params[:name]}%"])
      end

      if params[:actor_id].present?
        discussions = Pbls::Discussion.joins(:discussion_members).where('pbls_discussion_members.user_id' => params[:actor_id])
        project_ids = discussions.collect(&:project_id)
        @collections = @collections.where(id: project_ids)
      end

      if params[:subject].present? || params[:phase].present? || params[:technique].present?
        query_hash = request.query_parameters.delete_if {|key, value| key != 'subject' || key != 'phase' || key != 'technique'}
        ids = Pbls::Searcher.where(query_hash).collect(&:project_id)
        @collections = @collections.where(id: ids)
      end

      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    def release
      set_clazz_instance
     if @clazz_instance.release
       render :show, status: :ok
     else
       render json: {}, status: :unprocessable_entity
     end
    end

    private

    def configures
      {
        have_parent_resource: false,
        clazz: Pbls::Project
      }
    end

    def clazz_params
      params.fetch(:project, {}).permit!
      # (:name,
      #                                 :driven_issue,
      #                                 :standard_analysis,
      #                                 :duration,
      #                                 :limitation,
      #                                 :location_id,
      #                                 :location_id,
      #                                 :grade_id,
      #                                 :description,
      #                                 standard_decompositions_attributes: [:id, :role, :verb, :technique, :noun, :product_name, :_destroy])
    end

    def set_clazz_instance
      parse_includes
      @clazz_instance ||= configures[:clazz].includes(@include).find(params[:id]) rescue nil
    end

    def parse_includes
      include = params[:include] rescue nil
      if include
        @include = include.split(',')
        @include_techniques = include.include? 'techniques'
        @include_standard_items = include.include? 'standard_items'
        @include_rules = include.include? 'rules'
        @include_standard_decompositions = include.include? 'standard_decompositions'
        @include_knowledge = include.include? 'knowledge'
        @include_tasks = include.include? 'tasks'
        @include_region = include.include? 'region'
      end
    end

    def top_collections
      order = params[:order].try(:to_sym) || :desc

      @collections = configures[:clazz].order(created_at: order)
    end

  end
end