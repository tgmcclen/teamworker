# people supply by day
select days.date, sum(supplies.fte_ratio)
from days INNER JOIN supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) 
where days.work_day == 't'
group by days.date;

# AREL query - then run it throuh find_by_sql (Rails doesn't seem to properly support AREL yet!).  Once executed, the returned Days objects have a
# supply_fte_ratio property
d = Day.arel_table
s = Supply.arel_table
Day.find_by_sql(d.project('days.*, sum(supplies.fte_ratio) as supply_fte_ratio').join(s).on(d[:date].gteq(s[:start_date]).and(d[:date].lteq(s[:end_date]).or(s[:end_date].eq(nil)))).where(d[:work_day].eq(true)).group(d[:date]).order(d[:date].asc).to_sql)

# clunky old way, not using AREL and is slow - going to be deprecated in RAILS 3.1 (?)
Day.sum('supplies.fte_ratio', :conditions => { :work_day => true }, :joins => 'INNER JOIN supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) ', :group => 'days.date')

# people supply by month
select strftime("%Y%m", days.date), sum(supplies.fte_ratio)
from days INNER JOIN supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) 
where days.work_day == 't'
group by strftime("%Y%m", days.date);

# works but database implementation specific
Day.count(:select => 'strftime("%Y%m", days.date), count(*)', :conditions => { :work_day => true }, :joins => 'INNER JOIN supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) ', :group => 'strftime("%Y%m", days.date)')

