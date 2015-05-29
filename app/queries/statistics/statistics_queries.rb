class Statistics::StatisticsQueries
  def get_records(start_date = nil, end_date = nil, location_id = nil, pid = nil)
    query = StatisticRecord
      .joins{report}
      .includes{person}
      .includes{report}.includes{report.location}
      .includes{person}.includes{person.location}

    if start_date != nil && end_date != nil then
      query = query.where{(report.date >= start_date) & (report.date <= end_date)}
    end
    if location_id != nil then
      query = query.where{report.location_id == location_id}
    end
    if pid != nil then
      query = query.where{person_id == pid}
    end

    map = query.map { |obj| {
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

    map
  end
end