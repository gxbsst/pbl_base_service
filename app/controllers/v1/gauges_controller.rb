module V1
  class GaugesController < BaseController
    def index
      page = params[:page] || 1
      @limit = params[:limit] || 10

      @gauges = Gauge.order(created_at: :desc)
      @gauges = @gauges.where(id: params[:ids].gsub(/\s+/, "").split(',')) if params[:ids].present?
      @gauges = @gauges.page(page).per(@limit)
    end

    def show
      set_gauge

      if !@gauge
        render json: {}, status: :not_found
      end
    end

    def create
      @gauge = Gauge.new(gauge_params)

      if @gauge.save
        render :show, status: :created
      else
        render json: { error: @gauge.errors }, status: :unprocessable_entity
      end
    end

    def update
      set_gauge

      if @gauge.update_attributes(gauge_params)
        render :show, status: :ok
      else
        render json: {error: @gauge.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      set_gauge
      return head :not_found if !@gauge

      if @gauge.destroy
        render json: { id: @gauge.id }, status: :ok
      else
        head :unauthorized
      end
    end

    private
    def set_gauge
      include = params[:include] rescue nil
      @gauge ||= Gauge.includes(include).find(params[:id]) rescue nil
    end

    def gauge_params
      params.fetch(:gauge, {}).permit!
    end
  end
end