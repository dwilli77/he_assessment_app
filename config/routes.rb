# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:create] do
    post :grab_token, on: :collection
  end

  resources :books, only: %i[index create update destroy]

  get 'query', to: 'searches#search'
end
