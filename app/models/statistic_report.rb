class StatisticReport < ActiveRecord::Base
  belongs_to :location
  has_many :records, :class_name => "StatisticRecord"
end
