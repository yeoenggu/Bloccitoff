class Item < ActiveRecord::Base

  belongs_to :user

  # validates_associated :user
  # EG: why this won't work?  
  validates :user_id, presence: true
  validates :name, presence: true

  scope :sorted, -> { order(created_at: :desc) }

  def days_left
    days_since_creation = (DateTime.now.to_date - created_at.to_date).to_i
    7 - days_since_creation
  end
end
