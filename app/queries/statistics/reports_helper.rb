module Statistics::ReportsHelper
  def most_active_persons(persons, count = 3)
    persons.sort_by{ |x| -x[:quantity][:overall] }
           .take(count)
           .map{ |o| o[:person][:name] }
           .join(', ')
  end

  def most_active_locations(locations, count = 3)
    locations.sort_by{ |x| -x[:quantity][:overall] }
             .take(count)
             .map{ |obj| obj[:location][:name] }
             .join(', ')
  end

  def chart_labels(data)
    data.map { |obj| if obj[:month] == "01" then obj[:year] else " " end }.to_json
  end

  def chart_data(data)
    data.map { |obj| obj[:quantity] }.to_json
  end

  def overall_chart_data(data, years)
    [data.map{ |x| x[:quantity] }].to_json
  end

  def overall_chart_labels(data)
    #z = @current_year - years + 1
    #z=0
    m = ["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"]
    #labels = [0] * 12
    #labels.each_with_index.map {
    #  |o,i| i%12 == 0 ? i/12+z : m[i%12]
    #}.to_json
    data.map {|x| if x[:date].month == 1 then x[:date].year else m[x[:date].month-1] end }
  end

  def padright(a, n, x)
    a.dup.fill(x, a.length...n)
  end
end
