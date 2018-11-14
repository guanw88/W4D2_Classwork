# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :bigint(8)        not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, presence: true  
  
  validates :status, presence: true, inclusion: {
    in: ["APPROVED", "PENDING", "DENIED"], 
    message: "Invalid status" 
  }
  
  validate :valid_start_and_end_date, :does_not_overlap_approved_request
  
  belongs_to :cat,
    primary_key: :id,
    foreign_key: :cat_id, 
    class_name: "Cat" 
  
  def valid_start_and_end_date
    if self.start_date && self.end_date && self.start_date > self.end_date
      errors.add(:start_date, "cannot be after end date")
    end 
  end 
  
  def overlapping_requests 
    if self.start_date && self.end_date
      current_requests = CatRentalRequest
        .where(cat_id: self.cat_id)
        .where.not('end_date < ? OR start_date > ?', self.start_date, self.end_date)
    end 
  end
  
  def does_not_overlap_approved_request 
    if self.start_date && self.end_date && overlapping_approved_requests.exists?
      errors.add(:start_date, "cannot overlap approved request")
    end 
  end 
  
  def overlapping_approved_requests
    if self.start_date && self.end_date
      overlapping_requests.where(status: 'APPROVED')
    end 
  end 
  
  def overlapping_pending_requests
    if self.start_date && self.end_date
      overlapping_requests.where(status: 'PENDING')
    end 
  end 
  
  
end
