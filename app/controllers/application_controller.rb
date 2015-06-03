class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before filters
  before_filter :set_time
  before_filter :check_embedded

  private

  # check site is embedded
  def check_embedded
    @embedded = (params[:embedded] == 'true')
  end

  # set time variables
  def set_time
    @current_year = Time.now.year
  end
end
