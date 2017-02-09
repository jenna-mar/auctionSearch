Rails.application.routes.draw do
  resources :searches do
  	resources :listings
  end

  root 'home#index'
end
