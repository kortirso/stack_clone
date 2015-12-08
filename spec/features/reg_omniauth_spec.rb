require_relative 'feature_helper'

RSpec.feature "Omniauth management", :type => :feature do
    before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:facebook] = nil
        OmniAuth.config.mock_auth[:vkontakte] = nil
        OmniAuth.config.mock_auth[:twitter] = nil
        OmniAuth.config.mock_auth[:github] = nil
        visit root_path
    end

    describe 'Facebook sign in' do
        it 'success' do
            mock_auth_hash(:facebook)

            click_link 'Login through Facebook'

            expect(page).to have_content('test@gmail.com')
            expect(page).to have_content('Successfully authenticated from Facebook account')
        end

        it 'unsuccess' do
            invalid_mock_auth_hash(:facebook)

            click_link 'Login through Facebook'

            expect(page).to have_content 'You try to sign in with wrong credentials, its bad idea'
        end
    end

    describe 'Vkontakte sign in' do
        it 'success' do
            mock_auth_hash(:vkontakte)

            click_link 'Login through Vkontakte'

            expect(page).to have_content('test@gmail.com')
            expect(page).to have_content('Successfully authenticated from Vkontakte account')
        end

        it 'unsuccess' do
            invalid_mock_auth_hash(:vkontakte)

            click_link 'Login through Vkontakte'

            expect(page).to have_content 'You try to sign in with wrong credentials, its bad idea'
        end
    end

    describe 'Github sign in' do
        it 'success' do
            mock_auth_hash(:github)

            click_link 'Login through Github'

            expect(page).to have_content('test@gmail.com')
            expect(page).to have_content('Successfully authenticated from Github account')
        end

        it 'unsuccess' do
            invalid_mock_auth_hash(:github)

            click_link 'Login through Github'

            expect(page).to have_content 'You try to sign in with wrong credentials, its bad idea'
        end
    end

    describe 'Twitter sign in' do
        it 'success' do
            mock_auth_hash_twitter

            click_link 'Login through Twitter'

            expect(page).to have_content('Fill form with your email to finish sign_in process')

            fill_in 'user_email', with: 'test@gmail.com'
            click_on 'Send Email'

            expect(page).to have_content('test@gmail.com')
            expect(page).to have_content('Successfully authenticated from Twitter account')
        end

        it 'unsuccess' do
            invalid_mock_auth_hash(:twitter)

            click_link 'Login through Twitter'

            expect(page).to have_content 'You try to sign in with wrong credentials, its bad idea'
        end
    end
end