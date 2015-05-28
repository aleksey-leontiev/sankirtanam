class Statistics::ReportsController < ApplicationController
  include Statistics::OverallReportQueries
  include Statistics::AnnualReportQueries
  include Statistics::LocationReportQueries
  include Statistics::MonthlyReportQueries
  include Statistics::PersonalReportQueries

  before_action :authenticate_user!, only: [:new]

  # overall report
  def overall
    data        = overall_report_data
    @overall    = overall_report_chart_data(data)
    @locations  = overall_report_locations_data(data)
    @persons    = overall_report_persons_data(data)
    @quantity   = overall_report_all_quantity(data)
    @years      = data.uniq{ |x| x[:year] }.map{ |x|x[:year] }
    @mode       = data.length == 0 ? "no_data" : "ok"
  end

  # annual report
  def annual
    # get input parameters
    param_year = params[:year]

    # output params
    @year = param_year.to_i

    #
    data        = annual_report_data(@year)
    @chart_data = annual_report_chart_data(data)
    @locations  = annual_report_locations_data(data)
    @persons    = annual_report_persons_data(data)
    @quantity   = annual_report_all_quantity(data)
    @months     = [1,2,3,4,5,6,7,8,9,10,11,12]

    @no_data = @locations.length == 0
  end

  # location report
  def location
    # get input parameters
    param_year = params[:year]
    param_location = params[:location]

    if param_year && param_location then
      # output params
      @year = param_year.to_i
      @location = Location.find_by_url(param_location)
      location_id = @location.id

      # chart data
      @chart_data       = location_report_chart_data(param_year, location_id)
      @locations        = location_report_locations_data(param_year, location_id)
      @persons          = location_report_persons_data(param_year, location_id)
      @overall_quantity = location_report_all_quantity(param_year, location_id)

      @no_data = @chart_data.length == 0
    else
      @select_location = true
      @locations = Location.all.order(:name)
    end
  end

  # monthly report
  def monthly
    # get input parameters
    param_year = params[:year]
    param_month = params[:month]
    param_location = params[:location]

    # output params
    @year = param_year.to_i
    @month = param_month.to_i
    @location = Location.find_by_url(param_location)
    location_id = @location.id

    # active persons
    @persons = monthly_report_persons_data(param_year, param_month, location_id)
    @overall_quantity = @persons.map{|o| o[:quantity].to_i}.inject(:+)

    # no data found flag
    @no_data = @persons.length == 0
  end

  # annual report
  def personal
    # get input parameters
    param_id = params[:id]

    if param_id then
      @person = Person.find_by_id(param_id)

      # chart data
      data = personal_report_data(param_id)
      @chart = personal_report_chart_data(data)
      @table_data = personal_report_table_data(data)
      @overall_quantity = @table_data.map {|o| o[:quantity][:overall]}.inject(:+)
      @mode = (@person == nil || data.length == 0) ? "no_data" : "ok"
    else
      @mode = "select"
      @person = persons
    end
  end
end
