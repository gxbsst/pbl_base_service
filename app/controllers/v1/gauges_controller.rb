# encoding: utf-8
module V1
  class GaugesController < BaseController

    # === examples
    # ====  获取推荐量规
    #  /gauges/?technique_ids=:id1, :ids2
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      check_parent_resource_id if configures[:have_parent_resource]
      top_collections
      @collections = @collections.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      if params[:technique_ids].present?
        technique_ids = params[:technique_ids].split(',')
        @collections = @collections.where(technique_id: technique_ids)
      end
      @collections = @collections.order(reference_count: :desc, created_at: :desc).page(page).per(@limit) if @collections
    end

    def increase
      if params[:ids].present?
        ids = params[:ids].split(',')
        if Gauge.increment_counter(:reference_count, ids)
          render json: { id: ids }, status: :ok
        else
          head :unauthorized
        end
      end

      if params[:id].present?
        gauge = Gauge.find(params[:id])
        gauge.increment(:reference_count, 1)
        if gauge.save
          render json: { id: params[:id] }, status: :ok
        else
          head :unauthorized
        end
      end
    end

    def decrease
      if params[:ids].present?
        ids = params[:ids].split(',')
        if Gauge.decrement_counter(:reference_count, ids)
          render json: { id: ids }, status: :ok
        else
          head :unauthorized
        end
      end

      if params[:id].present?
        gauge = Gauge.find(params[:id])
        gauge.decrement(:reference_count, 1)
        if gauge.save
          render json: { id: params[:id] }, status: :ok
        else
          head :unauthorized
        end
      end
    end

    def recommends
      limit = params[:limit].try(:to_i) || 3
      technique_ids = params[:technique_ids].split(',')

      @gauges = Gauge.where(technique_id: technique_ids).find_by_sql ["SELECT * from (SELECT *, RANK() OVER (PARTITION BY technique_id  ORDER BY reference_count DESC) AS RP FROM gauges) G WHERE G.rp <= ?", limit]
      @collections = @gauges.group_by { |d| d.technique_id }
    end

    private

    def top_collections
      if configures[:have_parent_resource] && parent_resource_id.present?
        set_parent_resource_instance
        unless @parent_resource_instance
          return render json: {data: [], meta: {}}
        end
        @collections = @parent_resource_instance.send(:"#{configures[:clazz_resource_name]}")#.order(created_at: :desc)
      else
        @collections = configures[:clazz]#.order(created_at: :desc)
      end
    end

    def configures
      { have_parent_resource: false,
        clazz: Gauge }
    end

    def set_clazz_instance
      @clazz_instance ||= configures[:clazz].find(params[:id]) rescue nil
    end

    def clazz_params
      params.fetch(:gauge, {}).permit!
    end

  end
end