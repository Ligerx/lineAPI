Rails.application.routes.draw do
  resources :reservations
  resources :users
  resources :restaurants
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/:id/restaurants', to: 'users#restaurants', as: :userRestaurants
  get '/users/:id/restaurants/:restaurant_id', to: 'users#restaurant', as: :userRestaurant
  post '/users/:id/restaurants/:restaurant_id/make-reservation', to: 'users#make_reservation', as: :makeReservation
  post '/users/:id/restaurants/cancel-reservation', to: 'users#cancel_reservation', as: :cancelReservation

  get'/web', to: 'users#web'
  root 'users#web'
end
