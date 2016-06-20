Rails.application.routes.draw do
  devise_for :users
  root to: 'welcome#index'

  resources :users, only: [:index, :show], shallow: true do
    resources :authors
  end

  post 'gitlab/push', to: 'gitlab#push'
end
