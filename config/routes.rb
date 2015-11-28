Rails.application.routes.draw do
    devise_for :users
    concern :voteable do
        member do
            post 'vote_plus'
            post 'vote_minus'
            post 'devote'
        end
    end
    resources :questions, concerns: :voteable do
        resources :answers, concerns: :voteable
        get 'best/:id' => 'answers#best', as: 'best'
    end
    root to: 'questions#index'
end
