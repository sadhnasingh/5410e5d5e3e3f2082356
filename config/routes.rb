Rails.application.routes.draw do
  apipie
  namespace :api, defaults: {format: :json} do
  	resources :users
  end
end
