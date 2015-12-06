class Api::Statistics::ReportsController < ApplicationController
  before_action :authenticate_user!

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
      :name => param_location_name).first_or_create do |l|
        UserLocationAccess.create(user: current_user, location: l)
    end

    # check access rights
    cid = current_user.id
    rid = location.id
    has_access = current_user.admin? || (UserLocationAccess.where{
      (user_id == cid)&(location_id == rid)}.first != nil)

    if has_access then
      report = StatisticReport.where(
        :location => location,
        :date => date).first_or_create
      report.records.destroy_all()

      # insert records to report
      param_report.each do |row|
        person = Person.where(
          location: location,
          name: row[1]["name"] || "?").first_or_create
        record = StatisticRecord.new(
          :person => person,
          :huge   => row[1]["huge"]   || 0,
          :big    => row[1]["big"]    || 0,
          :medium => row[1]["medium"] || 0,
          :small  => row[1]["small"]  || 0)
        details = StatisticRecordDetails.new(
          :statistic_record => record,
          :d01 => row[1]["d01"] || 0,
          :d02 => row[1]["d02"] || 0,
          :d03 => row[1]["d03"] || 0,
          :d04 => row[1]["d04"] || 0,
          :d05 => row[1]["d05"] || 0,
          :d06 => row[1]["d06"] || 0,
          :d07 => row[1]["d07"] || 0,
          :d08 => row[1]["d08"] || 0,
          :d09 => row[1]["d09"] || 0,
          :d10 => row[1]["d10"] || 0,
          :d11 => row[1]["d11"] || 0,
          :d12 => row[1]["d12"] || 0,
          :d13 => row[1]["d13"] || 0,
          :d14 => row[1]["d14"] || 0,
          :d15 => row[1]["d15"] || 0,
          :d16 => row[1]["d16"] || 0,
          :d17 => row[1]["d17"] || 0,
          :d18 => row[1]["d18"] || 0,
          :d19 => row[1]["d19"] || 0,
          :d20 => row[1]["d20"] || 0,
          :d21 => row[1]["d21"] || 0,
          :d22 => row[1]["d22"] || 0,
          :d23 => row[1]["d23"] || 0,
          :d24 => row[1]["d24"] || 0,
          :d25 => row[1]["d25"] || 0,
          :d26 => row[1]["d26"] || 0,
          :d27 => row[1]["d27"] || 0,
          :d28 => row[1]["d28"] || 0,
          :d29 => row[1]["d29"] || 0,
          :d30 => row[1]["d30"] || 0,
          :d31 => row[1]["d31"] || 0,
          :scores => row[1]["scores"] || 0,
          :quantity => row[1]["quantity"] || 0

        )
        record.details = details
        report.records << record
      end
    end

    # render response
    render json: { result: has_access }
  end
end
