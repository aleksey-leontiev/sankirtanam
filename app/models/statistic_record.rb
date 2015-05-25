class StatisticRecord < ActiveRecord::Base
  belongs_to :report,
             :class_name => "StatisticReport",
             :foreign_key => "statistic_report_id",
             :inverse_of => :records
  belongs_to :person
  has_one :details,
          :class_name => "StatisticRecordDetails",
          :dependent  => :destroy
end
