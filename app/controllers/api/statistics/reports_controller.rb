class Api::Statistics::ReportsController < ApplicationController
  # creates new report using specified location, date and report's data
  #
  # query parameters:
  #   location: Name of location. If location is not exist it will be created.
  #   date    : Date of report.
  #   report  : Report table.
  #     name  : Person's name. It will be created for specified location if not found.
  #     huge  : Count of huge books.
  #     big   : Count of big books.
  #     medium: Count of medium books.
  #     small : Count of small books.
  #
  # response attributes:
  #   result: true - on success, otherwise - false.
  #
  # example:
  #   { location: 'spb', date: '01/2015', report: { name: 'Ivan', huge: 1, ...} } =>
  #   { result: true }
  def new
    # get input parameters
    param_location_name = params[:location]
    param_date          = params[:date]
    param_report        = params[:report]

    # find or create objects
    date = Date.strptime(param_date, "%m/%Y")
    location = Location.where(
      :name => param_location_name).first_or_create
    report = StatisticReport.where(
      :location => location,
      :date => date).first_or_create

    # insert records to report
    param_report.each do |row|
      person = Person.where(
        location: location,
        name: row[1]["name"]).first_or_create
      report.records << StatisticRecord.new(
        :person => person,
        :huge   => row[1]["huge"],
        :big    => row[1]["big"],
        :medium => row[1]["medium"],
        :small  => row[1]["small"])
    end

    # render response
    render json: { result: true }
  end
end
