class Statistics::ReportsController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  # overall report
  def overall
    queries     = Statistics::OverallReportQueries.new
    data        = queries.get_records()
    @overall    = queries.overall_report_chart_data(data)
    @locations  = queries.overall_report_locations_data(data)
    @persons    = queries.overall_report_persons_data(data)
    @quantity   = queries.overall_report_all_quantity(data)
    @years      = data.uniq{ |x| x[:year] }.map{ |x|x[:year] }
    @mode       = data.length == 0 ? "no_data" : "ok"
  end

  # annual report
  def annual
    # get input parameters
    param_year = params[:year]

    # output params
    @year = param_year.to_i

    start = Date.new(@year)
    finish = Date.new(@year, 12, 31)

    #
    queries     = Statistics::AnnualReportQueries.new
    data        = queries.get_records(start, finish)
    @chart_data = queries.annual_report_chart_data(data)
    @locations  = queries.annual_report_locations_data(data)
    @persons    = queries.annual_report_persons_data(data)
    @quantity   = queries.annual_report_all_quantity(data)
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
      location_id = @location.id.to_i

      start = Date.new(@year)
      finish = Date.new(@year, 12, 31)

      # chart data
      queries           = Statistics::LocationReportQueries.new
      data              = queries.get_records(start, finish, location_id)
      @chart_data       = queries.location_report_chart_data(data)
      @persons          = queries.location_report_persons_data(data)
      @overall_quantity = queries.location_report_all_quantity(data)
      @months           = [1,2,3,4,5,6,7,8,9,10,11,12]

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

    start = Date.new(@year, @month)
    finish = start.end_of_month

    # active persons
    queries           = Statistics::MonthlyReportQueries.new
    @persons = queries.get_records(start, finish, location_id)
    @overall_quantity = queries.monthly_report_all_quantity(@persons)

    # no data found flag
    @no_data = @persons.length == 0
  end

  # annual report
  def personal
    # get input parameters
    param_id = params[:id]
    queries = Statistics::PersonalReportQueries.new

    if param_id then
      @person = Person.find_by_id(param_id)

      # chart data
      data = queries.get_records(nil, nil, nil, param_id)
      @chart = queries.personal_report_chart_data(data)
      @table_data = queries.personal_report_table_data(data)
      @overall_quantity = @table_data.map {|o| o[:quantity][:overall]}.inject(:+)
      @mode = (@person == nil || data.length == 0) ? "no_data" : "ok"
    else
      @mode = "select"
      @person = queries.persons
    end
  end
end
