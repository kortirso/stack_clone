Rails.application.routes.draw do
    use_doorkeeper
    devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
    devise_scope :user do
        post '/finish_sign_up' => 'omniauth_callbacks#finish_sign_up', as: 'confirm_email'
        get '/users/auth/failure' => 'omniauth_callbacks#failure'
    end
    get 'search' => 'application#search', as: 'search'
    concern :voteable do
        member do
            post 'vote_plus'
            post 'vote_minus'
            post 'devote'
        end
    end
    concern :subscribeable do
        member do
            post 'subscribe'
            post 'unsubscribe'
        end
    end
    resources :questions, concerns: [:voteable, :subscribeable] do
        resources :comments, only: :create, defaults: {commentable: 'questions'}
        resources :answers, concerns: [:voteable] do
            resources :comments, only: :create, defaults: {commentable: 'answers'}
        end
        get 'best/:id' => 'answers#best', as: 'best'
    end
    namespace :api do
        namespace :v1 do
            resources :profiles do
                get :me, on: :collection
                get :all, on: :collection
            end
            resources :questions do
                resources :answers
            end
        end
    end
    root to: 'questions#index'
end
