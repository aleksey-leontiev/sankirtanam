class Statistics::PersonalReportQueries < Statistics::StatisticsQueries
  def persons
    Person.joins{location}.includes{location}
    .map { |obj|
      { id: obj.id, name: obj.name, location: obj.location.name }
    }.group_by { |obj|
      obj[:location]
    }.map { |obj|
      { location: obj[0],
        persons:  obj[1].sort_by{ |o| o[:name] } }
    }
  end
end