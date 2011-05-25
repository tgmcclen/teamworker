class Timebox < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :name
end
