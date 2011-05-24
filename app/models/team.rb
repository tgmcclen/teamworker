class Team < ActiveRecord::Base
  has_many :supplies
  attr_accessible :name
end
