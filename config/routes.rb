Rails.application.routes.draw do
    use_doorkeeper
    devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
    devise_scope :user do
        post '/finish_sign_up' => 'omniauth_callbacks#finish_sign_up', as: 'confirm_email'
        get '/users/auth/failure' => 'omniauth_callbacks#failure'
    end
    concern :voteable do
        member do
            post 'vote_plus'
            post 'vote_minus'
            post 'devote'
        end
    end
    resources :questions, concerns: [:voteable] do
        resources :comments, only: :create, defaults: {commentable: 'questions'}
        resources :answers, concerns: [:voteable] do
            resources :comments, only: :create, defaults: {commentable: 'answers'}
        end
        get 'best/:id' => 'answers#best', as: 'best'
    end
    namespace :api do
        namespace :v1 do
            resource :profiles do
                get :me, on: :collection
            end
        end
    end
    root to: 'questions#index'
end
