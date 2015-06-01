class Statistics::ReportsController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  # overall report
  def overall
    queries     = Statistics::OverallReportQueries.new
    @data       = queries.get_records()
    @locations  = queries.by_location(@data)
    @persons    = queries.by_person(@data)
    @quantity   = queries.overall_quantity(@data)
    @years      = @data.uniq{ |x| x[:year] }.map{ |x|x[:year] }.sort
    @mode       = @data.length == 0 ? "no_data" : "ok"
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
    @data       = queries.get_records(start_date: start, end_date: finish)
    @locations  = queries.by_location(@data)
    @persons    = queries.by_person(@data)
    @quantity   = queries.overall_quantity(@data)
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
      @data             = queries.get_records(start_date: start, end_date: finish, location_id: location_id)
      @persons          = queries.by_person(@data)
      @overall_quantity = queries.overall_quantity(@data)
      @months           = [1,2,3,4,5,6,7,8,9,10,11,12]

      @no_data = @data.length == 0
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
    @data          = queries.get_records(start_date: start, end_date: finish, location_id: location_id)
    @persons = queries.by_person(@data)
    @overall_quantity = queries.overall_quantity(@persons)

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
      data = queries.get_records(person_id: param_id)
      @chart = data
      @table_data = data.sort_by{ |x| x[:date] }
      @overall_quantity = @table_data.map {|o| o[:quantity][:overall]}.inject(:+)
      @mode = (@person == nil || data.length == 0) ? "no_data" : "ok"
    else
      @mode = "select"
      @person = queries.persons
    end
  end
end
