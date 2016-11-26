Rails.application.routes.draw do
  resources :reservations
  resources :users
  resources :restaurants
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/:id/restaurants', to: 'users#restaurants'

end
