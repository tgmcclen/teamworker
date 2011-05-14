namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Supply, Person, Day].each(&:delete_all)
        
    Person.populate 50 do |person|
      person.first_name = Faker::Name.first_name
      person.last_name = Faker::Name.last_name
      person.email = Faker::Internet.email
    end
    
    day_increment = Date.today
    Day.populate 400 do |day|
      day.date = day_increment
      day.work_day = ![6,7].include?(day_increment.cwday)
      day_increment = day_increment + 1
    end
  end
end