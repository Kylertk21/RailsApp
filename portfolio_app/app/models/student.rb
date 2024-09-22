class Student < ApplicationRecord
  validates:school_email, presence:true, uniqueness:true
  validates:first_name, presence:true
  validates:last_name, presence:true
  validates:grad_date, presence:true
  validates:major, presence:true
  has_one_attached :image
end
