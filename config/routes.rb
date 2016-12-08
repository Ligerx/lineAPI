Rails.application.routes.draw do
  resources :reservations
  resources :users
  resources :restaurants
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/:id/restaurants', to: 'users#restaurants', as: :user_restaurants
  get '/users/:id/restaurants/:restaurant_id', to: 'users#restaurant', as: :user_restaurant
  post '/users/:id/restaurants/:restaurant_id/make-reservation', to: 'users#make_reservation', as: :make_reservation
  post '/users/:id/restaurants/cancel-reservation', to: 'users#cancel_reservation', as: :cancel_reservation

  get'/web', to: 'users#web'
  root 'users#web'
end
