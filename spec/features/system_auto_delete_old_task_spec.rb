require 'rails_helper'
require 'rake'

feature 'System' do
  scenario 'delete tasks that are 7 days old' do

    # set up
    current_time = Time.now
    past_time = current_time - 8.days 

    no_of_items = Item.count
    travel_to past_time do
      task = create(:item)
      expect(Item.count).to eq(no_of_items+1)
    end

    rake = Rake.application
    rake.init
    rake.load_rakefile
    rake['todo:delete_items'].invoke()

    expect(Item.count).to eq(no_of_items)

  end
end