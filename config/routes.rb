Rails.application.routes.draw do
  root 'concert_info#index'
  resources :concert_info, only: [:index]
end
