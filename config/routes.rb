Rails.application.routes.draw do
  root to: 'welcome#index'

  devise_for :users, controllers: {registrations: 'users/registrations'}

  resources :users, only: [:index, :show], shallow: true do
    resources :authors
  end

  post 'gitlab/push', to: 'gitlab#push'
end
