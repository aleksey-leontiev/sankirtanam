module Statistics::OverallReportQueries
  #
  def overall_report_chart_data
    ActiveRecord::Base.connection.execute(
      "select     strftime('%Y', date)       as year,  " +
      "           strftime('%m', date)       as month, " +
      "           sum(huge+big+medium+small) as quantity " +
      "from       statistic_records rcd " +
      "inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "group by year, month"
    ).map { |obj|
      { year: obj["year"], month: obj["month"], quantity: obj["quantity"] }
    }
  end

  def overall_report_locations_data
    ActiveRecord::Base.connection.execute(
      "select strftime('%Y', date) as year, sum(huge+big+medium+small) as quantity, l.name as location_name, l.url as location_url " +
      "from statistic_records rcd " +
      "inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "inner join locations         l   on l.id   = rpt.location_id " +
      "group by l.id, year " +
      "order by l.id, year, quantity desc"
    ).map { |obj|
      { year: obj["year"], location_name: obj["location_name"],
        location_url: obj["location_url"], quantity: obj["quantity"] }
    }.group_by { |obj| # group by location
      { location_name: obj[:location_name], location_url: obj[:location_url] }
    }.map { |obj| # map to { location:"", data:[], quantity:00 }
      { location_name: obj[0][:location_name], location_url: obj[0][:location_url],
        data: [0,0,0,0].each_with_index.map {
          |o,i| (obj[1].detect{ |x|x[:year].to_i == i+1+@current_year-4}or{quantity:0})[:quantity]
        }
      }
    }.map! { |obj| # inject quantity
      obj[:quantity] = obj[:data].sum
      obj
    }.sort_by { |obj|
      obj[:quantity]
    }.reverse
  end

  def overall_report_persons_data
    ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) quantity, p.name, p.id as person_id, l.name as location, strftime('%Y', date) as year from statistic_records r " +
      "inner join people    p on r.person_id   = p.id " +
      "inner join locations l on p.location_id = l.id " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "group by p.id, year order by year, quantity desc"
    ).map { |obj|
      { name: obj["name"], quantity: obj["quantity"], location: obj["location"], year: obj["year"], person_id: obj["person_id"] }
    }.group_by { |obj| # group by location
      { name: obj[:name], location: obj[:location] }
    }.map { |obj| # map to { location:"", data:[], quantity:00 }
      { name: obj[0][:name], location: obj[0][:location], person_id: obj[1][0][:person_id],
        data: [0,0,0,0].each_with_index.map {
          |o,i| (obj[1].detect{ |x|x[:year].to_i == i+1+@current_year-4}or{quantity:0})[:quantity]
        }
      }
    }.map! { |obj| # inject quantity
      obj[:quantity] = obj[:data].sum
      obj
    }.sort_by { |obj|
      obj[:quantity]
    }.reverse
  end

  def overall_report_all_quantity
    ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) as quantity from statistic_records"
    )[0]["quantity"]
  end
end