Rails.application.routes.draw do

  mount TwoTierDefinitionx::Engine => "/two_tier_definitionx"
  mount Authentify::Engine => '/authentify'
  mount Commonx::Engine => '/common'
  
  root :to => "sessions#new", controller: :authentify
  get '/signin',  :to => 'sessions#new', controller: :authentify
  get '/signout', :to => 'sessions#destroy', controller: :authentify
  get '/user_menus', :to => 'user_menus#index', controller: :main_app
  get '/view_handler', :to => 'application#view_handler', controller: :authentify
end
