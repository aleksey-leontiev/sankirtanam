class Statistics::PersonalReportQueries < Statistics::StatisticsQueries
  def persons
    Person.joins{location}.includes{location}
    .map { |obj|
      { id: obj.id, name: obj.name, location: obj.location.name }
    }.group_by { |obj|
      obj[:location]
    }
  end
end