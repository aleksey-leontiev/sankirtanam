class Api::Statistics::PermissionsController < ApplicationController
  # check permission to send report for specified location, date and user
  #
  # query parameters:
  #   location: Name of location to check permission for. In case of location
  #             does not exist, "newLocation" attribute will be set true.
  #   date    : Date to check. Format: MM/YYYY.
  #   user    : User to check permission for.
  #
  # response attributes:
  #   result:      True/False.
  #   newLocation: Set to true in case of location does not exist.
  #   reportExist: Report for specified date and location already exist.
  def canSendReport
    # get parameters
    param_location_name = params[:location]
    param_date          = params[:date]
    param_user          = params[:user]

    # response
    response_result       = param_user == "admin"
    response_new_location = false
    response_report_exist = false

    # check location existence
    location = Location.find_by_name(param_location_name)
    date     = Date.strptime(param_date, "%m/%Y") if param_date != nil

    if date == nil then
      response_new_location = (location == nil)
    else
      if location != nil then
        report     = StatisticReport.find_by_location_id_and_date(location.id, date)
        response_report_exist = (report != nil)
      else
        response_report_exist = false
      end
    end

    # render json response
    render json: {
      result: response_result,
      newLocation: response_new_location,
      reportExist: response_report_exist }
  end
end
