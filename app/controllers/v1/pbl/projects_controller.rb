module V1
  class Pbl::ProjectsController < BaseController


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
  end
end