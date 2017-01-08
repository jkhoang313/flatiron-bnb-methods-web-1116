class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :valid_reservation

  def valid_reservation
    if !self.reservation
      errors.add(:reservation, "not associated")
    elsif self.reservation.status != "accepted"
      errors.add(:reservation, "not accepted")
    elsif self.reservation.checkout > Date.today
      errors.add(:reservation, "not past checkout")
    end
  end
end
