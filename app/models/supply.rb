class Supply < ActiveRecord::Base
  has_one :person
  attr_accessible :start_date, :end_date, :person_id
end
