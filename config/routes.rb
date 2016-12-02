Rails.application.routes.draw do
  resources :reservations
  resources :users
  resources :restaurants
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/:id/restaurants', to: 'users#restaurants'
  get '/users/:id/restaurants/:restaurant_id', to: 'users#restaurant'
  post '/users/:id/restaurants/:restaurant_id/make-reservation', to: 'users#make_reservation'
  post '/users/:id/restaurants/:restaurant_id/cancel-reservation', to: 'users#cancel_reservation'

end
