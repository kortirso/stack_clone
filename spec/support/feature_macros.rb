module FeatureMacros
    def sign_in(user)
        visit root_path
        within '#login' do
            fill_in 'user_email', with: user.email
            fill_in 'user_password', with: user.password
        end

        click_on 'Login'
    end
end