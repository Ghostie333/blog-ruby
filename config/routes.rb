Rails.application.routes.draw do
  get "notifications/index"
  resources :groups
  get "messages/create"
  get "chatrooms/index"
  get "chatrooms/show"
  get "friendships/index"
  get "user/show"


  devise_for :users, controllers: {
  sessions: "users/sessions",
  registrations: "users/registrations",
  passwords: "users/passwords"
}

  resources :posts do
    # /posts/:post_id/print
    resource :print, only: [ :show ], controller: :prints
    resources :comments
  end

  resources :user, only: [ :show ]

  # Routy dla znajomych
  resources :friendships, only: [ :index, :create, :update, :destroy ]

  # Routy dla chatów i wiadomości
  resources :chatrooms, only: [ :index, :show, :create ] do
    resources :messages, only: [ :create ] # Wiadomość zawsze w chacie, dlatego w chatrooms
  end

  # Namespace dla admina
  namespace :admin do
    resources :dashboards, only: [ :index ]
    resources :banned_ips, only: [ :index, :create, :destroy ]
    resources :users, only: [ :index, :update ]
    resources :activity_logs, only: [ :index ]
    resources :posts do
      resources :comments
    end
  end

  # Powiadomienia
  resources :notifications, only: [ :index ]


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "posts#index"
end
