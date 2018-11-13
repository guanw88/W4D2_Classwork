# == Schema Information
#
# Table name: cats
#
#  id          :bigint(8)        not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string           not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'date'

COLORS = ['Black', 'White', 'Brown']
class Cat < ApplicationRecord
  validates :birth_date, :name, :description, presence: true
   
  validate :birth_date_not_in_future
  
  validates :color, presence: true, inclusion: { 
    in: COLORS, 
    message: "Invalid color" 
  }
  
  validates :sex, presence: true, inclusion: { 
    in: %w(M F), 
    message: "Invalid gender" 
  }
  
  def birth_date_not_in_future
    if self.birth_date && self.birth_date > Date.today
      errors.add(:birth_date, "cannot be in the future")
    end 
  end 
  
  def age 
    now = Date.today 
    age = ((now - self.birth_date).to_i / 365.25).to_i
  end 
end
