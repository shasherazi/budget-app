Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  devise_scope :user do
    unauthenticated :user do
      root to: 'devise/sessions#splash', as: :unauthenticated_root
    end

    authenticated :user do
      root to: 'groups#index', as: :authenticated_root
    end
  end

  resources :groups do
  end
end
