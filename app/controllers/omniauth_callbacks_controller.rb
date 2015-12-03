class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_filter :authenticate_user!
    before_action :provides_callback, except: :failure

    def facebook
    end

    def vkontakte
    end

    def twitter
    end

    def github
    end

    def finish_sign_up
    end

    def failure
        render partial: 'shared/sign_up_failure'
    end

    private
    def provides_callback
        @user = User.find_for_oauth(get_omniauth)
        if @user
            sign_in_and_redirect @user, event: :authentication
            social = action_name == 'finish_sign_up' ? 'twitter' : action_name
            set_flash_message(:notice, :success, kind: "#{social}".capitalize) if is_navigational_format?
        else
            flash[:notice] = 'Email is needed'
            render partial: 'shared/confirm_email', locals: { auth: request.env["omniauth.auth"] }
        end
    end

    # либо передаются данные с соцсети с email, либо данные с соцсети + email из формы
    def get_omniauth
        env["omniauth.auth"] || OmniAuth::AuthHash.new(params[:auth])
    end
end