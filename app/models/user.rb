class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    User.where(id: User.joins("JOIN reservations ON reservations.guest_id = users.id").where(reservations: {listing_id: self.listings.pluck(:id)}).pluck(:id))
  end

  def hosts
    User.where(id: User.joins(:reservations).where(reservations: {listing_id: self.trips.pluck(:id)}).pluck(:id))
  end

  def host_reviews
    Review.where(guest_id: guests.pluck(:id))
  end
end
