require 'date'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  # def booked(start_date, end_date)
  #
  # end

  def city_openings(start_date, end_date)
    listings.where.not(id: booked_listings(start_date, end_date).pluck(:id))
  end

  def booked_listings(start_date, end_date)
    listings.joins(:reservations).where.not("reservations.checkin > ? OR reservations.checkout < ?", end_date, start_date)
  end

  def self.highest_ratio_res_to_listings
    self.find(self.joins(:reservations).group("neighborhoods.city_id").order("COUNT(*) DESC").pluck(:id).first)
  end

  def self.most_res
    self.find(self.joins(:reservations).group("neighborhoods.city_id").order("COUNT(*) DESC").pluck(:id).first)
  end
end
