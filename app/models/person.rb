class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :gravatar_email
end
