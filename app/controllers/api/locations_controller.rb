class Api::LocationsController < ApplicationController
  def index
    render json: Location.pluck(:name)
  end
end
