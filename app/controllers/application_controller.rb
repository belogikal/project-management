class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :missing_param

  private

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def missing_param
    render json: { error: 'Missing a required param' }, status: :unprocessable_entity
  end
end
