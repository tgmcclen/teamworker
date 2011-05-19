namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    days_start_variance = 100
    days_end_variance = 365
    [Absence, Supply, Person, Day].each(&:delete_all)
        
    Person.populate 50 do |person|
      person.first_name = Faker::Name.first_name
      person.last_name = Faker::Name.last_name
      person.email = Faker::Internet.email
      Supply.populate 1 do |supply|
          supply.person_id = person.id
          supply.start_date = Date.today..(Date.today + days_start_variance)
          supply.end_date = (supply.start_date + 28)..(supply.start_date + days_end_variance)
          supply.end_date = [supply.end_date, nil, nil]
          supply.fte_ratio = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.8, 0.6]
          Absence.populate 1 do |absence|
            absence.supply_id = supply.id
            if supply.end_date.nil?
              # absence can occur up to 365 (days_end_variance) after start date
              absence.start_date = supply.start_date..(supply.start_date + days_end_variance)
            else
              # absence can occur any time between start date and end date
              absence.start_date = supply.start_date..(supply.end_date)
            end
            # no more than a 4 week absence period (supply end date guaranteed to be at least 4 weeks after start date)
            absence.end_date = absence.start_date..(absence.start_date + 28)
          end
      end      
    end
    
    day_increment = Date.today
    Day.populate days_start_variance + days_end_variance do |day|
      day.date = day_increment
      day.work_day = ![6,7].include?(day_increment.cwday)
      day_increment = day_increment + 1
    end    
  end
end