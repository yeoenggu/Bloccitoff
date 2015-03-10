class Item < ActiveRecord::Base

  belongs_to :user

  # validates_associated :user
  # EG: why this won't work?  
  validates :user_id, presence: true
end
