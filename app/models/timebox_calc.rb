class TimeboxCalc
  attr_accessor :timebox_id, :start_date, :end_date, :name, :raw_supply_days, :absence_days, :work_days

  def initialize
    @absence_days = 0
    @raw_supply_days = 0
  end

  def supply_days
    @raw_supply_days - @absence_days
  end

  def supply_fte
    supply_days / work_days
  end

  def absence_fte
    absence_days / work_days
  end
  
  def self.calc_raw_supply_days(start_date = nil, end_date = nil)
    d = Day.arel_table
    s = Supply.arel_table
    t = Timebox.arel_table
    q = d.project('timeboxes.id, timeboxes.start_date, timeboxes.end_date, timeboxes.name, sum(supplies.fte_ratio) as raw_supply_days')
    .join(s, Arel::Nodes::OuterJoin).on(d[:date].gteq(s[:start_date]).and(d[:date].lteq(s[:end_date]).or(s[:end_date].eq(nil))))
    .join(t).on(d[:date].gteq(t[:start_date]).and(d[:date].lteq(t[:end_date])))
    .where(d[:work_day].eq(true))
    .group(t[:id], t[:start_date], t[:end_date], t[:name])
    .order(d[:date].asc)
    tighten_date_range(q, start_date, end_date)
    puts q.to_sql
    Day.find_by_sql(q.to_sql).collect do |t|
      tc = TimeboxCalc.new
      tc.timebox_id = t.id
      tc.start_date = t.start_date
      tc.end_date = t.end_date
      tc.name = t.name
      tc.raw_supply_days = t.raw_supply_days unless t.raw_supply_days.nil?
      tc
    end
  end

  def self.calc_absence_days(start_date = nil, end_date = nil)
    d = Day.arel_table
    a = Absence.arel_table
    s = Supply.arel_table
    t = Timebox.arel_table
    q = d.project('timeboxes.id, timeboxes.start_date, timeboxes.end_date, timeboxes.name, sum(supplies.fte_ratio) as absence_days')
    .join(t).on(d[:date].gteq(t[:start_date]).and(d[:date].lteq(t[:end_date])))
    .join(a).on(d[:date].gteq(a[:start_date]).and(d[:date].lteq(a[:end_date])))
    .join(s).on(a[:supply_id].eq(s[:id]))
    .where(d[:work_day].eq(true))
    .group(t[:id], t[:start_date], t[:end_date], t[:name])
    .order(d[:date].asc)
    tighten_date_range(q, start_date, end_date)
    puts q.to_sql
    Day.find_by_sql(q.to_sql).collect do |t|
      tc = TimeboxCalc.new
      tc.timebox_id = t.id
      tc.start_date = t.start_date
      tc.end_date = t.end_date
      tc.name = t.name
      tc.absence_days = t.absence_days unless t.absence_days.nil?
      tc
    end
  end

  def self.calc_work_days(start_date = nil, end_date = nil)
    d = Day.arel_table
    t = Timebox.arel_table
    q = d.project('timeboxes.id, timeboxes.start_date, timeboxes.end_date, timeboxes.name, count(*) as work_days')
    .join(t).on(d[:date].gteq(t[:start_date]).and(d[:date].lteq(t[:end_date])))
    .where(d[:work_day].eq(true))
    .group(t[:id], t[:start_date], t[:end_date], t[:name])
    .order(d[:date].asc)
    tighten_date_range(q, start_date, end_date)
    puts q.to_sql
    Day.find_by_sql(q.to_sql).collect do |t|
      tc = TimeboxCalc.new
      tc.timebox_id = t.id
      tc.start_date = t.start_date
      tc.end_date = t.end_date
      tc.name = t.name
      tc.work_days = t.work_days
      tc
    end
  end

  def self.calc_all(start_date = nil, end_date = nil)
    timeboxes = calc_raw_supply_days(start_date, end_date)
    work_days_timeboxes = calc_work_days(start_date, end_date)
    absence_timeboxes = calc_absence_days(start_date, end_date)

    # merge work days and absence days info into timebox calcs
    work_days_timeboxes.each do |w|
      t = timeboxes.detect { |t| w.timebox_id == t.timebox_id }
      t.work_days = w.work_days
    end
    absence_timeboxes.each do |a|
      t = timeboxes.detect { |t| a.timebox_id == t.timebox_id }
      t.absence_days = a.absence_days
    end
    timeboxes
  end
  
private
  def self.tighten_date_range(q, start_date, end_date)
    if start_date and end_date
      q.where(d[:date].gteq(start_date).and(d[:date].lteq(end_date)))
    elsif start_date
      q.where(d[:date].gteq(start_date))
    elsif end_date
      q.where(d[:date].lteq(end_date))
    end
  end

end