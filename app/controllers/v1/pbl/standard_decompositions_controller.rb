class V1::Pbl::StandardDecompositionsController < ApplicationController
  def create
    @standard_decomposition = Pbls::StandardDecomposition.new(standard_decomposition_params)

    if @standard_decomposition.save
      render :show, status: :created
    else
      render json: { error: @standard_decomposition.errors }, status: :unprocessable_entity
    end
  end

  def show
    set_standard_decomposition
  end

  def destroy
    set_standard_decomposition
    return head :not_found unless @standard_decomposition

    if @standard_decomposition.delete
      render json: { id: @standard_decomposition.id }, status: :ok
    else
      head :unauthorized
    end
  end

  private

  def standard_decomposition_params
    params.fetch(:standard_decomposition, {}).permit!
  end

  def set_standard_decomposition
    @standard_decomposition ||= Pbls::StandardDecomposition.find(params[:id]) rescue nil
  end
end
