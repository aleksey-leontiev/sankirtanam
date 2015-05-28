module Statistics::AnnualReportQueries
  # returns data for annual report
  #
  # { date, year, month, quantity, location: { name, url }, person: { id, name } }
  def annual_report_data(year)
    start = Date.new(year)
    finish = Date.new(year, 12, 31)
    StatisticRecord
      .joins{report}
      .includes{person}
      .includes{report}
      .includes{report.location}
      .includes{person.location}
      .where{(report.date >= start) & (report.date <= finish)}
      .map { |obj| {
      date:       obj.report.date,
      year:       obj.report.date.year,
      month:      obj.report.date.month,
      quantity:   obj.huge + obj.big + obj.medium + obj.small,
      location: { name: obj.report.location.name,
                  url:  obj.report.location.url },
      person:   { name: obj.person.name,
                  id:   obj.person.id,
                  location: { name: obj.person.location.name,
                              id:   obj.person.location.id } }
    } }
  end

  #
  def annual_report_chart_data(data)
    data.group_by { |obj| # group by date
      obj[:date]
    }.map { |obj|  # map to { date:"", quantity:[0, 0, 0] }
      { date:     obj[0],
        quantity: obj[1].sum{ |x| x[:quantity] } }
    }.sort_by{ |x| # sort by date
      x[:date]
    }
  end

  def annual_report_locations_data(data)
    data.group_by { |obj| # group by location
      obj[:location]
    }.map { |obj| # map to { location:"", quantity:{ overall, by_year:[{year, quantity}] }
      { location: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity]},
                    by_month: obj[1].group_by { |g| g[:month] }
                                   .map{ |y| {month: y[0], quantity: y[1].sum{|l| l[:quantity]}} }
                  } }
    }.sort_by { |obj| # sort by overall quantity
      obj[:quantity][:overall]
    }.reverse
  end

  def annual_report_persons_data(data)
    data.group_by { |obj| # group by person
      obj[:person]
    }.map { |obj| # map to { person, quantity:{ overall, by_year:[{year, quantity}] }
      { person: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity] },
                    by_month: obj[1].group_by { |g| g[:month] }
                                   .map{ |y| {month: y[0], quantity: y[1].sum{|l| l[:quantity]}} }
                  } }
    }.sort_by { |obj| # sort by overall quantity
      obj[:quantity][:overall]
    }.reverse
  end

  def annual_report_all_quantity(data)
    data.sum{ |x| x[:quantity] }
  end
end