class ReportController < ApplicationController

  def index
    dcs = DayCalc.calc_all
    @absence_fte = dcs.collect { |dc| dc.absence_fte }
    @raw_supply_fte = dcs.collect { |dc| dc.raw_supply_fte }
    @supply_fte = dcs.collect { |dc| dc.supply_fte }
    @dates = dcs.collect { |dc| dc.date }
  end

end
