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
  #
  # examples:
  #  new report for existing location:
  #    { location: spb } =>
  #    { result: true, newLocation: false }
  #
  #  new report for existing location:
  #    { location: spb, date: '01/2015' } =>
  #    { result: true, newLocation: false, reportExist: false }
  #
  #  new report for new location:
  #    { location: nowhere, date: '01/2015' } =>
  #    { result: true, newLocation: true, reportExist: false }
  def canSendReport
    # get parameters
    param_location_name = params[:location]
    param_date          = params[:date]
    param_user          = params[:user]

    # response
    response_result       = (param_user == "admin") # todo: check for real user
    response_new_location = false
    response_report_exist = false

    # check location existence
    report_location = Location.find_by_name(param_location_name)
    report_date     = Date.strptime(param_date, "%m/%Y") if param_date != nil

    # set response variables
    if report_location != nil && report_date != nil then
      response_report_exist = StatisticReport.where{
        (location == report_location) &
        (date     == report_date)}.first != nil
    elsif report_location != nil && param_date == nil
      response_new_location = (report_location == nil)
    elsif report_location == nil && report_date == nil
      response_new_location = true
    end

    # render json response
    render json: {
      result: response_result,
      newLocation: response_new_location,
      reportExist: response_report_exist }
  end
end
