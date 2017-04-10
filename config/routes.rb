# frozen_string_literal: true

Squawker::Application.routes.draw do
  resources :sessions,      only: %i[new create destroy]
  resources :squawks,       only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :password_resets

  resources :users do
    member do
      get :following, :followers
    end
  end

  root "static_pages#home"
  match "/home",    to: "static_pages#home",  via: "get"
  match "/about",   to: "static_pages#about", via: "get"
  match "/signup",  to: "users#new",          via: "get"
  match "/signin",  to: "sessions#new",       via: "get"
  match "/signout", to: "sessions#destroy",   via: "delete"
  match "/trial",   to: "sessions#trial",     via: "get"
end
