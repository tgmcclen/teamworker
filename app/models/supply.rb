class Supply < ActiveRecord::Base
  belongs_to :person
  belongs_to :team
  attr_accessible :start_date, :end_date, :person_id
end
