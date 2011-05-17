class Day < ActiveRecord::Base
  attr_accessible :date, :work_day, :holiday_name
  
  def self.all_supply_fte(start_date = nil, end_date = nil)
    # AREL query - then run it throuh find_by_sql (Rails doesn't seem to properly support AREL yet!).  
    # Once executed, the returned Days objects have a supply_fte property
    # TODO increase this to cover off sum absences and then net supply
    d = Day.arel_table
    s = Supply.arel_table
    q = d.project('days.*, sum(supplies.fte_ratio) as supply_fte')
    .join(s, Arel::Nodes::OuterJoin).on(d[:date].gteq(s[:start_date]).and(d[:date].lteq(s[:end_date]).or(s[:end_date].eq(nil))))
    .where(d[:work_day].eq(true))
    .group(d[:date])
    .order(d[:date].asc)

    if start_date and end_date
      q.where(d[:date].gteq(start_date).and(d[:date].lteq(end_date)))
    elsif start_date
      q.where(d[:date].gteq(start_date))
    elsif end_date
      q.where(d[:date].lteq(end_date))
    end
    logger.debug q.to_sql
    find_by_sql(q.to_sql)
  end
end
