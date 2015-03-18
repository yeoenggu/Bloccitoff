class Item < ActiveRecord::Base

  belongs_to :user

  # validates_associated :user
  # EG: why this won't work?  
  validates :user_id, presence: true

  scope :sorted, -> { order(created_at: :desc) }

  def days_left
    (DateTime.now.to_date - created_at.to_date).to_i
  end
end
