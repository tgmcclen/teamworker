class Person < ActiveRecord::Base
  has_many :supplies
  attr_accessible :first_name, :last_name, :email, :gravatar_email
end
