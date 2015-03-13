module Features
  module SessionHelpers
    def sign_in_user(user, password)

    fill_in('Email', with: user.email)
    fill_in('Password', with: password )
    
    click_button('Log in')

    end

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
end