module Statistics::OverallReportQueries
  def overall_report_data
    StatisticRecord
      .includes{person}
      .includes{report.location}
      .includes{person.location}
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
  def overall_report_chart_data(data)
    data.group_by { |obj| # group by location
      obj[:date]
    }.map { |obj| # map to { location:"", data:[], quantity:00 }
      { date: obj[0],
        quantity: obj[1].sum{ |l| l[:quantity] } }
    }.sort_by{ |x|
      x[:date]
    }
  end

  def overall_report_locations_data(data)
    data.group_by { |obj| # group by location
      obj[:location]
    }.map { |obj| # map to { location:"", data:[], quantity:00 }
      { location: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity]},
                    by_year: obj[1].group_by { |g| g[:year] }
                                   .map{ |y| {year: y[0], quantity: y[1].sum{|l| l[:quantity]}} }
                  } }
    }.sort_by { |obj|
      obj[:quantity][:overall]
    }.reverse
  end

  def overall_report_persons_data(data)
    data.group_by { |obj| # group by location
      obj[:person]
    }.map { |obj| # map to { location:"", data:[], quantity:00 }
      { person: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity] },
                    by_year: obj[1].group_by { |g| g[:year] }
                                   .map{ |y| {year: y[0], quantity: y[1].sum{|l| l[:quantity]}} }
                  } }
    }.sort_by { |obj|
      obj[:quantity][:overall]
    }.reverse
  end

  def overall_report_all_quantity(data)
    data.sum{|x| x[:quantity]}
  end
end