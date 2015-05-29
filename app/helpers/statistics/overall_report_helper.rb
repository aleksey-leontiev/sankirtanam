module Statistics::OverallReportHelper
  # returns string contains list of most active persons
  def most_active_persons(persons, count = 3)
    persons.sort_by{ |x| x[:quantity][:overall] }.reverse
           .take(count)
           .map{ |o| o[:person][:name] }
           .join(', ')
  end

  # returns string contains list of most active locations
  def most_active_locations(locations, count = 3)
    locations.sort_by{ |x| x[:quantity][:overall] }.reverse
             .take(count)
             .map{ |obj| obj[:location][:name] }
             .join(', ')
  end
end