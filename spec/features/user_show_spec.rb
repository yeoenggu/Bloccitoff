require 'rails_helper'

feature 'User show ' do
  scenario 'display user profile' do
    user = create(:user)

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password

    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
    expect(current_path).to eq(user_path(user))

    expect(page).to have_content(user.email)
    expect(page).to have_content(user.name)

  end
end
