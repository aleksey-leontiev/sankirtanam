module Statistics::MonthlyReportQueries
  # returns data for monthly report
  #
  # { date, year, month, quantity, location: { name, url }, person: { id, name } }
  def monthly_report_data(year, month, id)
    start = Date.new(year, month)
    finish = start.end_of_month
    StatisticRecord
      .joins{report}
      .includes{person}
      .includes{report.location}
      .includes{person.location}
      .where{report.location_id == id}
      .where{(report.date >= start) & (report.date <= finish)}
      .map { |obj| {
      date:       obj.report.date,
      year:       obj.report.date.year,
      month:      obj.report.date.month,
      quantity: { overall: obj.huge + obj.big + obj.medium + obj.small,
                  huge: obj.huge, big: obj.big, medium: obj.medium, small: obj.small },
      location: { name: obj.report.location.name,
                  url:  obj.report.location.url },
      person:   { name: obj.person.name,
                  id:   obj.person.id,
                  location: { name: obj.person.location.name,
                              id:   obj.person.location.id } }
    } }
  end

  def monthly_report_all_quantity(data)
    data.sum{ |x| x[:quantity][:overall] }
  end
end