Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  root 'concert_infos#index'
  resources :concert_infos, only: %i[index new] do
    collection do
      get 'hall_names'
    end
  end

  resource :export, only: :show
end
