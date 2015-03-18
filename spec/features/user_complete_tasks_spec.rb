require 'rails_helper'

RSpec.feature "User", type: :feature, js: true do
  scenario 'complete task' do
    page.driver.allow_url("fonts.googleapis.com")
    page.driver.allow_url("192.168.1.1")

    # set up
    password = "helloworld"
    user = create(:user, password: password)
    visit new_user_session_path
    sign_in_user(user, password)

    task_name = "Do it later"
    create_task(task_name)
    # verify that task is created.
    expect(page).to have_text("Task #{task_name} was successfully created.")
    task = Item.find_by(name: task_name)

    # exerceise
    # find the task and complete it
    within('#Task-table') do
      click_link("#{task.id}-complete")
    end
    wait_for_ajax
    # reload_page

    # verify
    # save_and_open_page
    # expect(page).to have_text("Task #{task_name} was completed.")
    expect(page).to have_css("#task-#{task.id}", visible: false)

    # tear down
    click_link "My Account"
    click_link "Log out"
  end

  private

  def reload_page
      visit page.driver.browser.current_url
  end

  def create_task(name, description="Some default description")
    click_link "New task"
    fill_in("Name", with: name)
    fill_in("Description", with: description)
    click_button("Create")
  end
end
