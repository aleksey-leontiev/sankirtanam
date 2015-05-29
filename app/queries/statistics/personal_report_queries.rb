class Statistics::PersonalReportQueries < Statistics::StatisticsQueries
  #
  def personal_report_chart_data(data)
    data.group_by { |obj| # group by date
      obj[:date]
    }.map { |obj|  # map to { date:"", quantity:[0, 0, 0] }
      { date:     obj[0],
        quantity: obj[1].sum{ |x| x[:quantity][:overall] } }
    }.sort_by{ |x| # sort by date
      x[:date]
    }
  end

  def personal_report_table_data(data)
    data.sort_by{ |x| # sort by date
      x[:date]
    }
  end

  def persons
    Person.joins{location}.includes{location}
    .map { |obj|
      { id: obj.id, name: obj.name, location: obj.location.name }
    }.group_by { |obj|
      obj[:location]
    }
  end
end