# frozen_string_literal: true

Rails.application.routes.draw do
  resources :articles do
    resources :comments
  end
  post 'account/verify_phone_number', to: 'account#verify_phone_number'
  post 'account/login_register', to: 'account#login_register'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
