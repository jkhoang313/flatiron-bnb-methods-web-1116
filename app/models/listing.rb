class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  def save
    self.host.update(host: true)
    super
  end

  def destroy
    self.host.update(host: false) if self.host.listings.count == 1
    super
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
