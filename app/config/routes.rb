require 'sidekiq/web'

Rails.application.routes.draw do
  get '/' => "pages#index"

  mount Sidekiq::Web => '/sidekiq'

  root to: redirect('/'), as: 'root'
end
