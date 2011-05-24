class Absence < ActiveRecord::Base
  belongs_to :supply
  attr_accessible :start_date, :end_date, :supply_id
  
  # TODO absence is not calculated properly when supply is part time (i.e. fte ratio is not 1).  i.e. if they are 0.6 fte ratio and they only have
  # one day off in a week then it would calculate (0.6 * 5) - 0.6 when it really should be (0.6 * 5) - 1. 
  # NOTE: This is not a problem if they have the entire week off.  In the scheme of things, its not a big deal.
end
