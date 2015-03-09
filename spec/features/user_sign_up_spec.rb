require 'rails_helper'

feature "Sign Up" do 
  # let(:user) { build(:user) }

  scenario 'Valid user', js: true do
    user = build(:user, password: "test password")
    page.driver.allow_url("fonts.googleapis.com")
    # not 100% sure whether we need to do this?
    reset_mailer
    visit "/"

    # Sign up
    click_link "Sign up"
    expect(current_path).to eq(new_user_registration_path)

    sign_up_user(user)
    expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
    expect(current_path).to eq("/")

    # Fetch the actual user to get user id which is needed by the user_path
    user = User.find_by(email: user.email)

    # Receive email and confirm account
    expect(unread_emails_for(user.email).count).to eq(1)
    open_email(user.email, with_subject: "Confirmation instructions")
    expect(current_email).to have_body_text("You can confirm your account email through the link below")
    click_first_link_in_email

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "Your email address has been successfully confirmed."

    # Log in now that your account is confirmed
    expect(page).to have_content('Log in')

    fill_in('Email', with: user.email)
    fill_in('Password', with: "test password")
    click_button('Log in')

    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Signed in successfully")
  end

  context "with invalid details: " do

    before do
      
      visit new_user_registration_path
    end

    scenario 'blank fields' do
      user = build(:user)

      expect(page).to have_field("Email", with: "", type: "email")
      expect(find_field("Password", type: "password").value).to be_nil
      expect(find_field("Password confirmation", type: "password").value).to be_nil

      click_button "Sign up"

      expect_error_messages "Email can't be blank", "Password can't be blank"
    end

    scenario 'incorrect email' do
      user = build(:user)

      sign_up_user(user, email: "invalid-email-for-testing")

      expect_error_messages "Email is invalid"
    end

    scenario 'email already taken' do
      user = build(:user)

      # Create the user first so that the email will be taken.
      create(:user, email: "hello@example.com")

      sign_up_user(user, email: "hello@example.com")

      expect_error_messages "Email has already been taken"
    end

    scenario 'invalid email format' do
      user = build(:user)

      sign_up_user(user, email: "SomeRubbish")
      # fill_in('Name', with: user.name)
      # fill_in('Email', with: "SomeRubbish")
      # fill_in('Password', with: user.password )
      # fill_in('Password confirmation', with: user.password)

      # click_button('Sign up')

      expect_error_messages "Email is invalid"
    end

    scenario 'password too short' do
      user = build(:user)

      wrong_password = "abc"
      sign_up_user(user, password: wrong_password, password_confirm: wrong_password)
      # fill_in('Name', with: user.name)
      # fill_in('Email', with: user.email)
      # fill_in('Password', with: wrong_password)
      # fill_in('Password confirmation', with: wrong_password)

      # click_button('Sign up')

      expect_error_messages("Password is too short (minimum is 8 characters)")
    end

    scenario 'password and password confirmation does not match' do
      user = build(:user)

      wrong_password = "abc"
      sign_up_user(user, password_confirm: wrong_password)
      # fill_in('Name', with: user.name)
      # fill_in('Email', with: user.email)
      # fill_in('Password', with: user.password )
      # fill_in('Password confirmation', with: wrong_password)

      # click_button('Sign up')

      expect_error_messages("Password confirmation doesn't match Password")

    end

  end

  private

  def sign_up_user(user, options = {})
    options.reverse_merge!({
      name: user.name,
      email: user.email,
      password: user.password,
      password_confirm: user.password
      })

    fill_in('Name', with: options[:name])
    fill_in('Email', with: options[:email])
    fill_in('Password', with: options[:password] )
    fill_in('Password confirmation', with: options[:password_confirm])
    click_button('Sign up')
  end

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