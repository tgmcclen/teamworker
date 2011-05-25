class DayCalc
  attr_accessor :day_id, :date, :raw_supply_fte, :absence_fte, :team_id

  def initialize
    @absence_fte = 0
    @raw_supply_fte = 0
  end

  def supply_fte
    @raw_supply_fte - @absence_fte
  end
  
  def self.calc_raw_supply_fte(start_date = nil, end_date = nil)
    # AREL query - then run it throuh find_by_sql (Rails doesn't seem to properly support AREL yet!).  
    # Once executed, the returned Days objects have a raw_supply_fte property
    d = Day.arel_table
    s = Supply.arel_table
    q = d.project('days.id, days.date, sum(supplies.fte_ratio) as raw_supply_fte')
    .join(s, Arel::Nodes::OuterJoin).on(d[:date].gteq(s[:start_date]).and(d[:date].lteq(s[:end_date]).or(s[:end_date].eq(nil))))
    .where(d[:work_day].eq(true))
    .group(d[:date])
    .order(d[:date].asc)
    tighten_date_range(q, start_date, end_date)
    puts q.to_sql
    Day.find_by_sql(q.to_sql).collect do |d|
      dc = DayCalc.new
      dc.day_id = d.id
      dc.date = d.date
      dc.raw_supply_fte = d.raw_supply_fte unless d.raw_supply_fte.nil?
      dc
    end
  end

  def self.calc_raw_supply_fte_for_teams(start_date = nil, end_date = nil)
    d = Day.arel_table
    s = Supply.arel_table
    t = Team.arel_table
    q = d.project('days.id, days.date, teams.id as team_id, sum(supplies.fte_ratio) as raw_supply_fte')
    .join(s, Arel::Nodes::OuterJoin).on(d[:date].gteq(s[:start_date]).and(d[:date].lteq(s[:end_date]).or(s[:end_date].eq(nil))))
    .join(t).on(t[:id].eq(s[:team_id]))
    .where(d[:work_day].eq(true))
    .group(d[:date], t[:id])
    .order(d[:date].asc)
    tighten_date_range(q, start_date, end_date)
    puts q.to_sql
    Day.find_by_sql(q.to_sql).collect do |d|
      dc = DayCalc.new
      dc.day_id = d.id
      dc.date = d.date
      dc.team_id = d.team_id
      dc.raw_supply_fte = d.raw_supply_fte unless d.raw_supply_fte.nil?
      dc
    end
  end

  def self.calc_absence_fte(start_date = nil, end_date = nil)
    d = Day.arel_table
    s = Supply.arel_table
    a = Absence.arel_table
    q = d.project('days.id, days.date, sum(supplies.fte_ratio) as absence_fte')
    .join(a).on(d[:date].gteq(a[:start_date]).and(d[:date].lteq(a[:end_date])))
    .join(s).on(a[:supply_id].eq(s[:id]))
    .where(d[:work_day].eq(true))
    .group(d[:date])
    .order(d[:date].asc)
    tighten_date_range(q, start_date, end_date)
    puts q.to_sql
    Day.find_by_sql(q.to_sql).collect do |d|
      dc = DayCalc.new
      dc.day_id = d.id
      dc.date = d.date
      dc.absence_fte = d.absence_fte unless d.absence_fte.nil?
      dc
    end
  end

  def self.calc_all(start_date = nil, end_date = nil)
    days = calc_raw_supply_fte(start_date, end_date)
    absence_days = calc_absence_fte(start_date, end_date)

    # merge absence days info into day calcs
    absence_days.each do |a|
      d = days.detect { |d| a.day_id == d.day_id }
      d.absence_fte = a.absence_fte
    end
    days
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