class Student < ApplicationRecord
  validates:first_name, presence:true, length: {maximum: 100}
  validates:last_name, presence:true, length: {maximum: 100}
  validates:grad_date, presence:true, length: {maximum: 100}
  validates:major, presence:true, length: {maximum: 255}
  has_one_attached :image
  validates :school_email, presence:true, length: {maximum: 255}, uniqueness:true, format: { 
    with: /\A[\w+\-.]+@msudenver\.edu\z/i,
    message: "must be a valid MSU Denver email address"
  }
end

