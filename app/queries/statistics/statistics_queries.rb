class Statistics::StatisticsQueries
  # returns list of records
  def get_records(start_date: nil, end_date: nil, location_id: nil, person_id: nil, order: nil)
    # general query
    query = StatisticRecord
      .joins{report}
      .joins{details.outer}
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
      quantity: { overall: calculate_books(obj),
                  huge: obj.huge, big: obj.big, medium: obj.medium, small: obj.small },
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

  def by_location(data)
    data.group_by { |obj| # group by location
      obj[:location]
    }.map { |obj| # map to { location:"", quantity:{ overall, by_year:[{year, quantity}] }
      { location: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity][:overall] },
                    by_year: obj[1].group_by { |g| g[:year] }
                                   .map{ |y| {year: y[0], quantity: y[1].sum{|l| l[:quantity][:overall] }} }
                  } }
    }.sort_by { |obj| # sort by overall quantity
      obj[:quantity][:overall]
    }.reverse
  end

  def by_person(data)
    data.group_by { |obj| # group by person
      obj[:person]
    }.map { |obj| # map to { person, quantity:{ overall, by_year:[{year, quantity}] }
      { person: obj[0],
        quantity: { overall: obj[1].sum{ |l| l[:quantity][:overall] },
                    huge: obj[1][0][:quantity][:huge], big: obj[1][0][:quantity][:big],
                    medium: obj[1][0][:quantity][:medium], small: obj[1][0][:quantity][:small],
                    by_year: obj[1].group_by { |g| g[:year] }
                                   .map{ |y| {year: y[0], quantity: y[1].sum{|l| l[:quantity][:overall] }} }
                  } }
    }.sort_by { |obj| # sort by overall quantity
      obj[:quantity][:overall]
    }.reverse
  end

  def overall_quantity(data)
    data.sum{ |x| x[:quantity][:overall] }
  end

  def years(data)
    data.uniq{|x|x[:year]}.map{|x|x[:year]}.sort
  end


  protected

  def calculate(obj)
    if obj.details != nil then
      obj = obj.details
      if obj.scores && obj.scores != 0 then return obj.scores || 0 end
      if obj.quantity && obj.quantity != 0 then return obj.quantity || 0 end

      (obj.d01 || 0) + (obj.d02 || 0) + (obj.d03 || 0) + (obj.d04 || 0) + (obj.d05 || 0) + (obj.d06 || 0) + (obj.d07 || 0) + (obj.d08 || 0) +
      (obj.d09 || 0) + (obj.d10 || 0) + (obj.d11 || 0) + (obj.d12 || 0) + (obj.d13 || 0) + (obj.d14 || 0) + (obj.d15 || 0) + (obj.d16 || 0) +
      (obj.d17 || 0) + (obj.d18 || 0) + (obj.d19 || 0) + (obj.d20 || 0) + (obj.d21 || 0) + (obj.d22 || 0) + (obj.d23 || 0) + (obj.d24 || 0) +
      (obj.d25 || 0) + (obj.d26 || 0) + (obj.d27 || 0) + (obj.d28 || 0) + (obj.d29 || 0) + (obj.d30 || 0) + (obj.d31 || 0)
    else
      (obj.huge || 0) + (obj.big || 0) + (obj.medium || 0) + (obj.small || 0)
    end
  end

  def calculate_books(obj)
    if obj.details != nil then
      obj = obj.details
      if obj.quantity && obj.quantity != 0 then return obj.quantity || 0 end

      (obj.d01 || 0) + (obj.d02 || 0) + (obj.d03 || 0) + (obj.d04 || 0) + (obj.d05 || 0) + (obj.d06 || 0) + (obj.d07 || 0) + (obj.d08 || 0) +
      (obj.d09 || 0) + (obj.d10 || 0) + (obj.d11 || 0) + (obj.d12 || 0) + (obj.d13 || 0) + (obj.d14 || 0) + (obj.d15 || 0) + (obj.d16 || 0) +
      (obj.d17 || 0) + (obj.d18 || 0) + (obj.d19 || 0) + (obj.d20 || 0) + (obj.d21 || 0) + (obj.d22 || 0) + (obj.d23 || 0) + (obj.d24 || 0) +
      (obj.d25 || 0) + (obj.d26 || 0) + (obj.d27 || 0) + (obj.d28 || 0) + (obj.d29 || 0) + (obj.d30 || 0) + (obj.d31 || 0)
    else
      (obj.huge || 0) + (obj.big || 0) + (obj.medium || 0) + (obj.small || 0)
    end
  end

end