Rails.application.routes.draw do
  root 'concert_infos#index'
  resources :concert_infos, only: %i[index new] do
    collection do
      get 'hall_names'
    end
  end

  resource :excel, only: :show
end
