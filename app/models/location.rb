class Location < ActiveRecord::Base
  has_many :reports,
           :class_name => "StatisticReport",
           :dependent => :destroy
end
