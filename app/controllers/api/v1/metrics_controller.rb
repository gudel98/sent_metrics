class Api::V1::MetricsController < ApplicationController
  def keyword_density
    calculation_result = KeywordDensityCalculationService.call(permitted_params)

    render json: calculation_result
  end

  private

  def permitted_params
    params.permit(:app_id, :start_date, :end_date, :term, :visualize)
  end
end
