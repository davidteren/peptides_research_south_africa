Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest, defaults: { format: :json }
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker, defaults: { format: :js }
  get "saved" => "saved_compounds#index", as: :saved

  resources :compounds, only: %i[index show], param: :id
  resources :providers, only: %i[index show], param: :id

  root "home#index"
end
