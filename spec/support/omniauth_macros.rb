module OmniauthMacros
    def mock_auth_hash(provider)
        OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
            provider: provider.to_s, uid: '123456', info: { email: 'test@gmail.com' }
        })
    end

    def mock_auth_hash_twitter
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
            provider: 'twitter', uid: '123456', info: {}
        })
    end

    def invalid_mock_auth_hash(provider)
        OmniAuth.config.on_failure = Proc.new { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
        OmniAuth.config.mock_auth[provider] = :invalid_credentials
    end
end