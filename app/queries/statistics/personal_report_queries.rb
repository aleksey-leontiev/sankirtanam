module Statistics::PersonalReportQueries
  #
  def personal_report_chart_data(id)
    ActiveRecord::Base.connection.execute(
      "select     strftime('%Y', date)       as year,    " +
      "           strftime('%m', date)       as month,   " +
      "           sum(huge+big+medium+small) as quantity " +
      "from       statistic_records rcd " +
      "inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "where      rcd.person_id = '#{id}' " +
      "group by   year, month " +
      "order by   date "
    ).map { |obj|
      { quantity: obj["quantity"], year: obj["year"], month: obj["month"] }
    }
  end

  def personal_report_data(id)
    ActiveRecord::Base.connection.execute(
      "select     strftime('%Y', date)       as year,     " +
      "           strftime('%m', date)       as month,    " +
      "           huge+big+medium+small      as quantity, " +
      "           huge, big, medium, small " +
      "from       statistic_records rcd " +
      "inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "where      rcd.person_id = '#{id}' " +
      "order by   date "
    ).map { |obj|
      { quantity: obj["quantity"], year: obj["year"], month: obj["month"],
        huge: obj["huge"], big: obj["big"], medium: obj["medium"], small: obj["small"] }
    }
  end

  def persons
    ActiveRecord::Base.connection.execute(
      "select p.id as id, p.name as person_name, l.name as location_name " +
      "from people p " +
      "inner join locations l on p.location_id = l.id " +
      "order by l.name, p.name"
    ).map { |obj|
      { id: obj["id"], name: obj["person_name"], location: obj["location_name"] }
    }.group_by { |obj|
      obj[:location]
    }
  end
end