Rails.application.routes.draw do

  root to: "home#index"
  #Team
  resources :team
  #ressources pour les produits dans le panier
  resources :line_items

  #resources pours les paniers
  resources :carts, only: [:new, :create, :destroy, :show]

  #resources pour les produits
  resources :products

  #resources for admin
  resources :admin, only: [:new, :create, :destroy]

  #resources for user_session
  resources :session

  #creationuser
  resources :user do
  	resources :message , only: [ :new , :index , :destroy , :create , :edit , :update]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
