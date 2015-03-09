require 'rails_helper'

feature 'User' do
  scenario 'create task', js: true do
    page.driver.allow_url("fonts.googleapis.com")
    page.driver.allow_url("192.168.1.1")
    
    #set up
    password = "helloworld"
    user = create(:user, password: password)
    visit new_user_session_path
    sign_in_user(user, password)
    # Fetch the actual user to get user id which is needed by the user_path
    user = User.find_by(email: user.email)

    # exercise
    click_link "New task"

    expect(current_path).to eq(new_user_item_path(user.id))

    task_name = Faker::Lorem.word
    task_description = Faker::Lorem.sentence
    fill_in("Name", with: task_name)
    fill_in("Description", with: task_description)
    click_button("Create")

    # verify
    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Task was successfully created.")
    expect(page).to have_text(task_name)
    expect(page).to have_text(task_description) 
    
    #tear down
    click_link "My Account"
    click_link "Log out"
  end

  private

  def sign_in_user(user, password)

    fill_in('Email', with: user.email)
    fill_in('Password', with: password )
    
    click_button('Log in')
  end
end