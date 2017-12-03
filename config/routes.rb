Rails.application.routes.draw do
  root 'concert_infos#index'
  resource :concert_infos, only: %i[index new]
end
