Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :compounds, only: %i[index show], param: :id
  resources :providers, only: %i[index show], param: :id

  root "home#index"
end
