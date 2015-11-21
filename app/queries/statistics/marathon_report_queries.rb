class Statistics::MarathonReportQueries < Statistics::StatisticsQueries
  # returns list of records
  def get_records(start_date: nil, end_date: nil, location_id: nil, person_id: nil, order: nil)
    # general query
    query = StatisticRecord
      .joins{report}
      .joins{details}
      .includes{person}
      .includes{report}.includes{report.location}
      .includes{person}.includes{person.location}
      .includes{details}

    ## apply filters ##

    # filter by date
    query = query.where{
      (report.date >= start_date) & (report.date <= end_date)
    } if start_date != nil && end_date != nil

    # filter by location
    query = query.where{
      report.location_id == location_id
    } if location_id != nil

    # filter by person
    query = query.where{
      self.person_id == person_id
    } if person_id != nil

    ## map records ##

    map = query.map { |obj| {
      date:       obj.report.date,
      year:       obj.report.date.year,
      month:      obj.report.date.month,
      quantity: { overall: obj.details.scores || obj.details.quantity,
                  huge: obj.huge, big: obj.big, medium: obj.medium, small: obj.small,
                  details: obj.details
      },
      location: { name: obj.report.location.name,
                  url:  obj.report.location.url },
      person:   { name: obj.person.name,
                  id:   obj.person.id,
                  location: { name: obj.person.location.name,
                              id:   obj.person.location.id } }
    } }

    #map.sort{|x| x[:quantity][:overall] } if order == :overall_quantity
    map = map.sort_by{|x| x[:date] } if order == :date

    map
  end

  def by_person(data)
    data.group_by { |obj| # group by person
      obj[:person]
    }.map { |obj| # map to { person, quantity:{ overall, by_year:[{year, quantity}] }
      { person: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity][:overall] },
                    details: obj[1][0][:quantity][:details] }
      }
    }.sort_by { |obj| # sort by overall quantity
      obj[:quantity][:overall]
    }.reverse
  end
end