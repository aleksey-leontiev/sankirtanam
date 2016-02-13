class Statistics::ReportsController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  # overall report
  def overall
    @og_description = "Личный отчет"

    queries = Statistics::OverallReportQueries.new
    records = queries.get_records()

    @data = {
      records:     records,
      by_location: queries.by_location(records),
      by_person:   queries.by_person(records),
      quantity:    queries.overall_quantity(records),
      years:       queries.years(records) }
    @mode = (records.length == 0 ? :no_data : :ok)
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
    queries   = Statistics::MonthlyReportQueries.new
    @data     = queries.get_records(start_date: start, end_date: finish, location_id: location_id)
    @persons  = queries.by_person(@data)
    @overall_quantity = queries.overall_quantity(@persons)

    # no data found flag
    @no_data = @persons.length == 0
  end

  # personal report
  # /statistics/reports/personal/:id-:name
  def personal
    # get input parameters
    param_id    = params[:id]
    param_year  = params[:year]
    param_month = params[:month]
    queries  = Statistics::PersonalReportQueries.new

    if param_id then
      @person = Person.find_by_id(param_id)

      start_date = param_year && param_month ? Date.new(param_year.to_i, param_month.to_i) : nil
      end_date   = start_date != nil ? start_date.end_of_month : nil

      @data      = queries.get_records(person_id: param_id, start_date: start_date, end_date: end_date, order: :date)
      @quantity  = @data.map { |o| o[:quantity][:overall] }.inject(:+)
      @mode      = (@person == nil || @data.length == 0) ? :no_data : :ok
      @types     = {overall: "Книг", huge: "Махабиги", big: "Большие", medium: "Средние", small: "Малые"}
      @date      = "#{param_month}/#{param_year}"
      @huge_view = (param_month != nil) && (param_year != nil)
    else
      @mode   = :select
      @person = queries.persons
    end
  end

  def marathon
    # get input parameters
    param_year  = params[:year].to_i
    param_month = (params[:month] || 12).to_i
    param_days = (params[:days] || 31).to_i
    @year = param_year.to_i

    queries = Statistics::MarathonReportQueries.new
    start   = Date.new(@year, param_month)
    finish  = Date.new(@year, param_month, param_days)

    @data      = queries.get_records(start_date: start, end_date: finish)
    @persons   = queries.by_person(@data).take(15)
    @locations = queries.by_location(@data)
  end

  def help
  end
end
