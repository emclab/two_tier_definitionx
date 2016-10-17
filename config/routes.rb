TwoTierDefinitionx::Engine.routes.draw do
  resources :definitions
  resources :sub_definitions
  root :to => 'definitions#index'
end
