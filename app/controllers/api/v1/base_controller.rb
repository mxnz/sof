class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  private
    def current_resource_owner
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token.present?
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error_message: exception.message }, status: :not_found
    end

end
