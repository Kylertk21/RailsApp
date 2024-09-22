class Student < ApplicationRecord
  # Ensures school email is valid and unique
  validates:school_email, presence:true, uniqueness:true
  validates:first_name, presence:true
  validates:last_name, presence:true
  validates:grad_date, presence:true
  validates:major, presence:true
end
