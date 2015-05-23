module Statistics::LocationReportQueries
  #
  def location_report_chart_data(year, location_id)
    r = [0,0,0,0,0,0,0,0,0,0,0,0]

    ActiveRecord::Base.connection.execute(
      "select     strftime('%Y', date)       as year,  " +
      "           strftime('%m', date)       as month, " +
      "           sum(huge+big+medium+small) as quantity " +
      "from       statistic_records rcd " +
      "inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "where      year = '#{year}' and rpt.location_id = '#{location_id}'" +
      "group by   month"
    ).map { |obj|
      { quantity: obj["quantity"], month: obj["month"] }
    }.each { |o|
      r[o[:month].to_i] = o[:quantity]
    }
    r
  end

  def location_report_locations_data(year, location_id)
    ActiveRecord::Base.connection.execute(
      "select strftime('%Y', date) as year, strftime('%m', date) as month, sum(huge+big+medium+small) as quantity, l.name as location " +
      "from statistic_records rcd inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "inner join locations l on l.id == rpt.location_id " +
      "where year = '#{year}' and rpt.location_id = '#{location_id}'" +
      "group by l.id, month order by l.id, month, quantity desc"
    ).map { |obj| { # convert raw data
        year: obj["year"],         month: obj["month"],
        location: obj["location"], quantity: obj["quantity"] }
    }.group_by { |obj| # group by location
      obj[:location]
    }.map { |obj| # map to { location:"", data:[], quantity:00 }
      { location: obj[0],
        data: [0,0,0,0,0,0,0,0,0,0,0,0].each_with_index.map {
          |o,i| (obj[1].detect{ |x|x[:month].to_i == i+1}or{quantity:0})[:quantity]
        }
      }
    }.map! { |obj| # inject quantity
      obj[:quantity] = obj[:data].sum
      obj
    }.sort_by { |obj|
      obj[:quantity]
    }.reverse
  end

  def location_report_persons_data(year, location_id)
    ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) quantity, p.name, p.id as person_id, l.name as location, strftime('%m', date) as month from statistic_records r " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "inner join people    p on r.person_id   = p.id " +
      "inner join locations l on p.location_id = l.id " +
      "where strftime('%Y', date) = '#{year}' and rpt.location_id = '#{location_id}'" +
      "group by p.id, month order by p.id, month asc, quantity desc"
    ).map { |obj|
      { name: obj["name"], quantity: obj["quantity"], location: obj["location"], month: obj["month"], person_id: obj["person_id"] }
    }.group_by { |obj|
      { name: obj[:name], location: obj[:location] }
    }.map { |obj|
      { name: obj[0][:name], location: obj[0][:location], person_id: obj[1][0][:person_id],
        data: [0,0,0,0,0,0,0,0,0,0,0,0].each_with_index.map {
          |o,i| (obj[1].detect{ |x|x[:month].to_i == i+1}or{quantity:0})[:quantity]
        }
      }
    }.map! { |obj| # inject quantity
      obj[:quantity] = obj[:data].sum
      obj
    }.sort_by { |obj|
      obj[:quantity]
    }.reverse
  end

  def location_report_all_quantity(year, location_id)
    ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) as quantity from statistic_records r " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "where strftime('%Y', date) = '#{year}' and rpt.location_id = '#{location_id}'"
    )[0]["quantity"]
  end
end