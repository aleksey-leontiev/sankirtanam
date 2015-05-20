module Statistics::ReportsHelper
  def three_most_active_persons(persons)
    persons.take(3).map{ |o| o[:name] }.join(', ')
  end

  def three_most_active_locations(locations)
    locations.take(3).map{ |obj| obj[:location_name] }.join(', ')
  end

  def chart_labels(data)
    data.map { |obj| if obj[:month] == "01" then obj[:year] else " " end }.to_json
  end

  def chart_data(data)
    data.map { |obj| obj[:quantity] }.to_json
  end

  def padright(a, n, x)
    a.dup.fill(x, a.length...n)
  end
end
