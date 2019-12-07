Rails.application.routes.draw do
  resources :profile_items, only: [:create, :update, :destroy]
  resources :profile_item_categories
  resources :privacy_group_members, only: [:create, :update, :destroy]
  resources :privacy_groups
  get 'facebook', to: 'privacy_groups#facebook', as: "facebook"
  resources :seekings
  # get 'compatibilities/unrated', :to => 'compatibilities#unrated_index'
  # get 'compatibilities/rated', :to => 'compatibilities#rated_index'
  # get 'compatibilities/dealbreakers', :to => 'compatibilities#dealbreakers_index'
  # resources :compatibilities
  # resources :match_people
  resources :activities do
    resources :users
  end
  resources :connection_requests
  resources :connections
  #devise_for :users, :controllers => { :oauth => "users/oauth" }
  resources :categories
  resources :checks, only: [:create, :index]
  post "api/profiles/text_profile_item", to: "profile_items#create_text_profile_item", as: "create_text_profile_item"
  get "api/profile_item_categories/:id/options", to: "profile_item_categories#get_options", as: "get_options"
  put "api/checks/new", to: "checks#create_check", as: "create_check", defaults: { format: 'json' }
  delete "api/checks/delete", to: "checks#destroy_check", as: "destroy_check"
  put "api/privacy_group_member/new", to: "privacy_group_members#create_member", as: "create_member", defaults: { format: 'json' }
  delete "api/privacy_group_member/delete", to: "privacy_group_members#destroy_member", as: "destroy_member"

  put "api/connection_token_expiration/:id", to: "connection_tokens#update_expiration", as: "update_expiration", defaults: { format: 'json' }

  resources :connection_tokens
  # get "connection_token/:token", to: "connections#token", as: "connection_token_thing"

  resources :profiles

  resources :text_profile_item
  resources :gender
  resources :profile_item_responses

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'

  get 'sign_up', to: 'users#new'
  post 'sign_up', to: 'users#create'

  resources :sessions, only: [:new, :create]
  delete :sessions, to: 'sessions#destroy'

  resources :password_resets
  resources :users

  OAuthIdentity.provider_names.each do |provider|
    post "users/auth/#{provider}/callback" => "oauth/#{provider}#callback"
    get "users/auth/#{provider}/callback" => "oauth/#{provider}#callback"
    get "oauth/#{provider}" => "oauth/#{provider}#redirect_for_login"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root 'compatibilities#index'
  root 'checks#index'
end
