# people supply by day
select days.date, sum(supplies.fte_ratio)
from days
left outer join supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) 
where days.work_day == 't'
group by days.date;

select days.date, sum(supplies.fte_ratio)
from days 
left outer join supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) 
where days.work_day == 't'
group by days.date;

# clunky old way, not using AREL and is slow - going to be deprecated in RAILS 3.1 (?)
Day.sum('supplies.fte_ratio', :conditions => { :work_day => true }, :joins => 'INNER JOIN supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) ', :group => 'days.date')

# people absences by day
select days.date, sum(supplies.fte_ratio)
from days 
inner join absences on days.date >= absences.start_date and days.date <= absences.end_date 
inner join supplies on absences.supply_id = supplies.id
where days.work_day == 't'
group by days.date;

select days.date, absences.id, absences.start_date, absences.end_date, supplies.id, supplies.fte_ratio
from days 
inner join absences on days.date >= absences.start_date and days.date <= absences.end_date 
inner join supplies on absences.supply_id = supplies.id
where days.work_day == 't'

# people supply by month
select strftime("%Y%m", days.date), sum(supplies.fte_ratio)
from days INNER JOIN supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) 
where days.work_day == 't'
group by strftime("%Y%m", days.date);

# works but database implementation specific
Day.count(:select => 'strftime("%Y%m", days.date), count(*)', :conditions => { :work_day => true }, :joins => 'INNER JOIN supplies on days.date >= supplies.start_date and (days.date <= supplies.end_date or supplies.end_date IS NULL) ', :group => 'strftime("%Y%m", days.date)')

