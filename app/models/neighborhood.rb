class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    listings.where.not(id: booked_listings(start_date, end_date).pluck(:id))
  end

  def booked_listings(start_date, end_date)
    listings.joins(:reservations).where.not("reservations.checkin > ? OR reservations.checkout < ?", end_date, start_date)
  end

  def self.highest_ratio_res_to_listings
    self.find(self.joins(:reservations).group("neighborhood_id").order("COUNT(*) DESC").limit(1).pluck(:id).first)
  end

  def self.most_res
    self.find(self.joins(:reservations).group("neighborhood_id").order("COUNT(*) DESC").limit(1).pluck(:id).first)
  end
end
