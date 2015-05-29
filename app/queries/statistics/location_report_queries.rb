class Statistics::LocationReportQueries < Statistics::StatisticsQueries
  #
  def location_report_chart_data(data)
    data.group_by { |obj| # group by date
      obj[:date]
    }.map { |obj|  # map to { date:"", quantity:[0, 0, 0] }
      { date:     obj[0],
        quantity: obj[1].sum{ |x| x[:quantity][:overall] } }
    }.sort_by{ |x| # sort by date
      x[:date]
    }
  end

  def location_report_persons_data(data)
    data.group_by { |obj| # group by person
      obj[:person]
    }.map { |obj| # map to { person, quantity:{ overall, by_year:[{year, quantity}] }
      { person: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity][:overall] },
                    by_month: obj[1].group_by { |g| g[:month] }
                                   .map{ |y| {month: y[0], quantity: y[1].sum{|l| l[:quantity]}} }
                  } }
    }.sort_by { |obj| # sort by overall quantity
      obj[:quantity][:overall]
    }.reverse
  end

  def location_report_all_quantity(data)
    data.sum{ |x| x[:quantity][:overall] }
  end
end