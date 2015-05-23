class Statistics::ReportsController < ApplicationController
  include Statistics::OverallReportQueries

  # overall report
  def overall
    @data       = overall_report_chart_data
    @locations  = overall_report_locations_data
    @persons    = overall_report_persons_data
    @quantity   = overall_report_all_quantity
    @years      = [@current_year-3, @current_year-2, @current_year-1, @current_year]
  end

  # annual report
  def annual
    # get input parameters
    param_year = params[:year]

    # output params
    @year = param_year.to_i

    # chart data
    @chart_data = annual_chart_data(param_year)

    # active locations
    @locations = ActiveRecord::Base.connection.execute(
      "select strftime('%Y', date) as year, strftime('%m', date) as month, sum(huge+big+medium+small) as quantity, l.name as location, l.url as location_url " +
      "from statistic_records rcd inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "inner join locations l on l.id == rpt.location_id " +
      "where year = '#{param_year}' " +
      "group by l.id, month order by l.id, month, quantity desc"
    ).map { |obj| { # convert raw data
        year: obj["year"],         month: obj["month"],
        location: obj["location"], quantity: obj["quantity"],
        location_url: obj["location_url"] }
    }.group_by { |obj| # group by location
      { location: obj[:location], location_url: obj[:location_url] }
    }.map { |obj| # map to { location:"", data:[], quantity:00 }
      { location: obj[0][:location], location_url: obj[0][:location_url],
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

    # active persons
    @persons = ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) quantity, p.name, p.id as person_id, l.name as location, strftime('%m', date) as month from statistic_records r " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "inner join people    p on r.person_id   = p.id " +
      "inner join locations l on p.location_id = l.id " +
      "where strftime('%Y', date) = '#{param_year}' " +
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

    # overall quantity
    # @persons.map{|o| o[:quantity].to_i}.inject(:+)
    @overall_quantity = ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) as quantity from statistic_records r " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "where strftime('%Y', date) = '#{param_year}' "
    )[0]["quantity"]

    @no_data = @chart_data.length == 0
  end

  # location report
  def location
    # get input parameters
    param_year = params[:year]
    param_location = params[:location]

    if param_year && param_location then

    # output params
    @year = param_year.to_i
    @location = Location.find_by_url(param_location)
    location_id = @location.id

    # chart data
    @chart_data = location_chart_data(param_year, location_id)

    # active locations
    @locations = ActiveRecord::Base.connection.execute(
      "select strftime('%Y', date) as year, strftime('%m', date) as month, sum(huge+big+medium+small) as quantity, l.name as location " +
      "from statistic_records rcd inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "inner join locations l on l.id == rpt.location_id " +
      "where year = '#{param_year}' and rpt.location_id = '#{location_id}'" +
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

    # active persons
    @persons = ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) quantity, p.name, p.id as person_id, l.name as location, strftime('%m', date) as month from statistic_records r " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "inner join people    p on r.person_id   = p.id " +
      "inner join locations l on p.location_id = l.id " +
      "where strftime('%Y', date) = '#{param_year}' and rpt.location_id = '#{location_id}'" +
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

    # overall quantity
    # @persons.map{|o| o[:quantity].to_i}.inject(:+)
    @overall_quantity = ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) as quantity from statistic_records r " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "where strftime('%Y', date) = '#{param_year}' and rpt.location_id = '#{location_id}'"
    )[0]["quantity"]

    @no_data = @chart_data.length == 0
    else
      @select_location = true
      @locations = Location.all.order(:name)
    end
  end

  # monthly report
  def monthly
    # get input parameters
    param_year = params[:year]
    param_month = params[:month]
    param_location = params[:location]

    # output params
    @year = param_year.to_i
    @month = param_month.to_i
    @location = Location.find_by_url(param_location)
    location_id = @location.id

    # active persons
    @persons = ActiveRecord::Base.connection.execute(
      "select huge+big+medium+small as quantity, p.name, p.id as person_id, r.huge, r.big, r.medium, r.small from statistic_records r " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "inner join people    p on r.person_id   = p.id " +
      "where strftime('%Y', date) = '#{param_year}' and rpt.location_id = '#{location_id}' and strftime('%m', date)='#{param_month}' " +
      "order by quantity desc"
    ).map { |obj|
      { name: obj["name"], quantity: obj["quantity"], huge: obj["huge"], big: obj["big"], medium: obj["medium"], small: obj["small"], person_id: obj["person_id"] }
    }

    # overall quantity
    @overall_quantity = @persons.map{|o| o[:quantity].to_i}.inject(:+)

    # no data found flag
    @no_data = @persons.length == 0
  end

  # annual report
  def personal
    # get input parameters
    param_id = params[:id]

    @person = Person.find_by_id(param_id)

    # chart data
    @chart_data = personal_chart_data(param_id)
    @table_data = personal_data(param_id)
    @overall_quantity = @table_data.map {|o| o[:quantity]}.inject(:+)

    @no_data = @chart_data.length == 0
  end

  private

  def overall_chart_data
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

  def annual_chart_data(year)
    ActiveRecord::Base.connection.execute(
      "select     strftime('%Y', date)       as year,  " +
      "           strftime('%m', date)       as month, " +
      "           sum(huge+big+medium+small) as quantity " +
      "from       statistic_records rcd " +
      "inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "where      year = '#{year}' " +
      "group by   month"
    ).map { |obj|
      { quantity: obj["quantity"] }
    }
  end

  def location_chart_data(year, location_id)
    ActiveRecord::Base.connection.execute(
      "select     strftime('%Y', date)       as year,  " +
      "           strftime('%m', date)       as month, " +
      "           sum(huge+big+medium+small) as quantity " +
      "from       statistic_records rcd " +
      "inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "where      year = '#{year}' and rpt.location_id = '#{location_id}'" +
      "group by   month"
    ).map { |obj|
      { quantity: obj["quantity"] }
    }
  end

  def personal_chart_data(id)
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

  def personal_data(id)
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
end
