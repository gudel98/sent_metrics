class Api::V1::MetricsController < ApplicationController
  def keyword_density
    @data = KeywordDensityCalculationService.call(permitted_params)

    if permitted_params[:visualize] == "true"
      @request_params = permitted_params
      render template: "api/v1/metrics/keyword_density", layout: false, formats: [ :html ]
    else
      render json: @data
    end
  end

  private

  def permitted_params
    params.permit(:app_id, :start_date, :end_date, :term, :visualize)
  end
end
