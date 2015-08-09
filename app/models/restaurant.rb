class Restaurant < ActiveRecord::Base
  before_save { self.unique_name = name.downcase }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :wait, presence: true, numericality: { greater_than_or_equal_to: 0 } 
  validates :address, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  acts_as_votable

  # Define a search method for dynamic search purposes
  def self.search(search)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      all
    end
  end
end
