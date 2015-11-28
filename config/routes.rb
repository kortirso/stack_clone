Rails.application.routes.draw do
    devise_for :users
    concern :voteable do
        member do
            post 'vote_plus'
            post 'vote_minus'
            post 'devote'
        end
    end
    concern :commentable do
        member do
            post 'comment_add'
        end
    end
    resources :questions, concerns: [:voteable, :commentable] do
        resources :answers, concerns: [:voteable, :commentable]
        get 'best/:id' => 'answers#best', as: 'best'
    end
    root to: 'questions#index'
end
