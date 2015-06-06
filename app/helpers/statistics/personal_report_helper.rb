module Statistics::PersonalReportHelper
  # returns string contains class for row
  def row_class(row)
    row[:month].to_i == 1 ? 'warning' : ''
  end
end