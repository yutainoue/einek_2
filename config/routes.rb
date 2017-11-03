Rails.application.routes.draw do
  resources :concert_info, only: [:index]
end
