Rails.application.routes.draw do
  # La ruta "raíz" va a devolver el html básico
  root to: "main#main"

  devise_for :users, controllers: {
    sessions: 'sessions', registrations: 'users'
  }
  devise_scope :user do
    post "/session" => "sessions#create"
  end

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  # Rutas para los recursos relacionados con Customer
  resources :customers, except: [:new, :edit], concerns: :paginatable do
  # Rutas para los recursos relacionados con Project
    resources :projects, only: [:index, :create]
  end

  resources :projects, only: [:show, :update, :destroy] do
    resources :tasks, only: [:index, :create]
  end

  # Rutas para los recursos relacionados con Task
  resources :tasks, only: [:show, :update, :destroy]
end
