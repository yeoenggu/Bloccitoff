class Item < ActiveRecord::Base
  belongs_to :user

  def create
    Item.create(create_params)
  end

  def create_params
    # last stop.  i need rails c to figure out syntax and parameters
    # I need name: string, user_id in order to create an item
    # how about checking for duplicate?
    
    # params.require()
  end
end
