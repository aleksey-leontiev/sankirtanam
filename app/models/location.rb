class Location < ActiveRecord::Base
  has_many :reports,
           :class_name => "StatisticReport",
           :dependent => :destroy

  before_save do
    self.url = ActiveSupport::Inflector::transliterate(name.downcase).gsub(/ /, "-")
  end
end
