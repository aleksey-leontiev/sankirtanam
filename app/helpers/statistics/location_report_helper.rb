module Statistics::LocationReportHelper
  # converts overall data for chart
  def location_chart_data(data)
    range  = [1,2,3,4,5,6,7,8,9,10,11,12]
    [range.map{ |x|
      (data.detect{ |y| y[:date].month == x } or { quantity:0 })[:quantity]
    }].to_json
  end
end