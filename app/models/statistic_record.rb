class StatisticRecord < ActiveRecord::Base
  belongs_to :statistic_report
  belongs_to :person
  has_one :details, :class_name => "StatisticRecordDetails"
end
