require 'rails_helper'

feature "Sign Up" do 
  let(:user) { build(:user) }

  scenario 'Valid user', js: true do
    page.driver.allow_url("fonts.googleapis.com")
    # not 100% sure whether we need to do this?
    reset_mailer
    visit "/"

    # Sign up
    click_link "Sign up"
    expect(current_path).to eq(new_user_registration_path)

    fill_in('Name', with: user.name)
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password )
    fill_in('Password confirmation', with: user.password)
    click_button('Sign up')

    
    expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
    expect(current_path).to eq("/")

    # Receive email and confirm account
    expect(unread_emails_for(user.email).count).to eq(1)
    open_email(user.email, with_subject: "Confirmation instructions")
    expect(current_email).to have_body_text("You can confirm your account email through the link below")
    click_first_link_in_email

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "Your email address has been successfully confirmed."

    # Log in now that your account is confirmed
    expect(page).to have_content('Log in')
    fill_in('Name', with: user.name)
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password )
    click_button('Log in')

    expect(current_path).to eq("/")
    expect(page).to have_text("Signed in successfully")
  end

  context "with invalid details: " do

    before do
      visit new_user_registration_path
    end

    scenario 'blank fields' do
      

      expect(page).to have_field("Email", with: "", type: "email")
      expect(find_field("Password", type: "password").value).to be_nil
      expect(find_field("Password confirmation", type: "password").value).to be_nil

      click_button "Sign up"

      expect_error_messages "Email can't be blank", "Password can't be blank"
    end

    scenario 'incorrect email' do
     

      fill_in('Name', with: user.name)
      fill_in("Email", with: "invalid-email-for-testing")
      fill_in('Password', with: user.password )
      fill_in('Password confirmation', with: user.password)

      click_button "Sign up"

      expect_error_messages "Email is invalid"
    end

    scenario 'email already taken' do
      

      create(:user, email: "hello@example.com")

      fill_in('Name', with: user.name)
      fill_in('Email', with: "hello@example.com")
      fill_in('Password', with: user.password )
      fill_in('Password confirmation', with: user.password)

      click_button "Sign up"

      expect_error_messages "Email has already been taken"
    end

    scenario 'invalid email format' do
      

      fill_in('Name', with: user.name)
      fill_in('Email', with: "SomeRubbish")
      fill_in('Password', with: user.password )
      fill_in('Password confirmation', with: user.password)

      click_button('Sign up')

      expect_error_messages "Email is invalid"
    end

    scenario 'password too short' do
      

      wrong_password = "abc"
      fill_in('Name', with: user.name)
      fill_in('Email', with: user.email)
      fill_in('Password', with: wrong_password)
      fill_in('Password confirmation', with: wrong_password)

      click_button('Sign up')

      expect_error_messages("Password is too short (minimum is 8 characters)")
    end

    scenario 'password and password confirmation does not match' do
      

      wrong_password = "abc"
      fill_in('Name', with: user.name)
      fill_in('Email', with: user.email)
      fill_in('Password', with: user.password )
      fill_in('Password confirmation', with: wrong_password)

      click_button('Sign up')

      expect_error_messages("Password confirmation doesn't match Password")

    end

  end

  private

  def expect_error_messages(*messages)

    within "#error_explanation" do
      error_count = messages.size
      expect(page).to have_content "#{error_count} #{'error'.pluralize(error_count)} prohibited this user from being saved"
      within "ul" do
        expect(page).to have_css "li", count: error_count
        messages.each do |expected_msg|
          expect(page).to have_selector "li", text: expected_msg
        end
      end
    end
  end

end