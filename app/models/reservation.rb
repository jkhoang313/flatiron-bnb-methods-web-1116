class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_cannot_be_host
  validate :check_in_available
  validate :check_out_available
  validate :check_in_before_check_out, if: [:checkin, :checkout]
  validate :check_in_different_check_out

  def guest_cannot_be_host
    if self.guest == self.listing.host
      errors.add(:guest, "cannot be host")
    end
  end

  def check_in_available
    if !self.listing.reservations.where("reservations.checkin < ? AND reservations.checkout > ?", checkin, checkin).empty?
      errors.add(:check_in, "not available")
    end
  end

  def check_out_available
    if !self.listing.reservations.where("reservations.checkin < ? AND reservations.checkout > ?", checkout, checkout).empty?
      errors.add(:check_out, "not available")
    end
  end

  def check_in_before_check_out
    if checkin > checkout
      errors.add(:check_in, "must be before checkout")
    end
  end

  def check_in_different_check_out
    if checkin == checkout
      errors.add(:check_in, "must be different from checkout")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    (self.listing.price * duration).to_i
  end
end
