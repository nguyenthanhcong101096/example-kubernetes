Rails.application.routes.draw do
  get '/' => "pages#index"

  root to: redirect('/'), as: 'root'
end
