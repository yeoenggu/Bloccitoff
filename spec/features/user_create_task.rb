require 'rails_helper'

feature 'User' do
  scenario 'create task', js: true do
    #set up
    user = build(:user)
    visit "/"
    click_link "Sign in"

    # exercise
    click_link "New task"

    expect(path).to be(new_user_item_path)
    task_name = Faker::Lorem.word
    task_description = Faker::Lorem.sentence
    fill_in("Name", with: task_name)
    fill_in("Description", with: task_description)
    click_button("Create")
    # verify
    # Fetch the actual user to get user id which is needed by the user_path
    user = User.find_by(email: user.email)

    expect(path).to be(user_path(user))
    expect(page).to have_text(task_name)
    expect(page).to have_text(task_description) 
    
    #tear down
    click_link "Sign out"
  end
end