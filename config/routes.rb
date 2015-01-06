TwoTierDefinitionx::Engine.routes.draw do
  resources :definitions
  resources :sub_definitions, :only => [:index]
  root :to => 'definitions#index'
end
