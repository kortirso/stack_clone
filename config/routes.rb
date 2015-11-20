Rails.application.routes.draw do
    devise_for :users
    resources :questions do
        resources :answers
        get 'best/:id' => 'answers#best', as: 'best'
    end
    root to: 'questions#index'
end
