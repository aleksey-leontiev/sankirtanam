module Statistics::PersonalReportQueries
  # returns data for personal report
  #
  # { date, year, month, quantity, location: { name, url }, person: { id, name } }
  def personal_report_data(id)
    StatisticRecord
      .includes{person}
      .includes{report.location}
      .includes{person.location}
      .where{person_id == id}
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