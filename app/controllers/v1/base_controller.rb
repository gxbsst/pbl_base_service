# encoding: utf-8
module V1
  class BaseController < ActionController::API
    include ActionController::MimeResponds
    include ActionController::ImplicitRender

    before_action :set_locale

    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @collections = @collections.page(page).per(@limit) if @collections
    end

    def show
      set_clazz_instance

      if !@clazz_instance
        render json: {}, status: :not_found
      end
    end

    def create
      check_parent_resource_id if configures[:have_parent_resource]
      @clazz_instance = configures[:clazz].new(clazz_params)

      if @clazz_instance.save
        render :show, status: :created
      else
        render json: { error: @clazz_instance.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_clazz_instance

      if @clazz_instance.update_attributes(clazz_params)
        render :show, status: :ok
      else
        render json: {error: @clazz_instance.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_clazz_instance
      return head :not_found if !@clazz_instance

      if @clazz_instance.destroy
        render json: { id: @clazz_instance.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def configures
     fail 'implement the method e.g as below'
      # === examples
      # {
      #   have_parent_resource: true,
      #   parent_resource_clazz: Pbls::Project,
      #   clazz: Pbls::Rule,
      #   resource_name: rules
      # }
    end

    def clazz_params
      fail 'implement the method e.g as below'
      #  params.fetch(:rule, {}).permit!
    end

    def parent_resource_id
      fail 'implement the method e.g as below'
      #   params[:project_id] || params[:rule][:project_id]
      # rescue
      #   nil
    end

    def top_collections
      if configures[:have_parent_resource] && parent_resource_id.present?
        set_parent_resource_instance
        unless @parent_resource_instance
          return render json: {data: [], meta: {}}
        end
        @collections = @parent_resource_instance.send(:"#{configures[:clazz_resource_name]}").order(created_at: :desc)
      else
        @collections = configures[:clazz].order(created_at: :desc)
      end
    end

    def set_parent_resource_instance
      @parent_resource_instance ||= configures[:parent_resource_clazz].find(check_parent_resource_id) rescue nil
    end

    def check_parent_resource_id
      # fail 'No Parent Resource Id' unless parent_resource_id
      parent_resource_id
    end

    def set_clazz_instance
      include = params[:include] rescue nil
      @clazz_instance ||= configures[:clazz].includes(include || @include).find(params[:id]) rescue nil
    end

    def set_locale
      I18n.locale = (params[:locale] || 'robot') || I18n.default_locale
    end

    def query
      keys = configures[:query]
      query_hash = request.query_parameters.delete_if {|key, value| !keys.include?(key)}

      @collections = @collections.where(query_hash) if query_hash.present?
    end

  end
end
