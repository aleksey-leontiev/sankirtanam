class Statistics::LocationReportQueries < Statistics::StatisticsQueries
  def by_person(data)
    data.group_by { |obj| # group by person
      obj[:person]
    }.map { |obj| # map to { person, quantity:{ overall, by_year:[{year, quantity}] }
      { person: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity][:overall] },
                    by_month: obj[1].group_by { |g| g[:month] }
                                   .map{ |y| {month: y[0], quantity: y[1].sum{|l| l[:quantity][:overall] }} }
                  } }
    }.sort_by { |obj| # sort by overall quantity
      obj[:quantity][:overall]
    }.reverse
  end
end