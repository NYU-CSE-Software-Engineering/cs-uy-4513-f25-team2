Rails.application.routes.draw do
  # Home
  get  '/home', to: 'home#index', as: :home
  root to: 'home#index'

  # Signup
  resources :learners, only: [:new, :create]

  # Login/Logout
  get    '/login',  to: 'logins#new',    as: :new_login
  post   '/login',  to: 'logins#create', as: :login
  delete '/logout', to: 'logins#delete', as: :logout

  # Sessions
  resources :tutor_sessions, path: 'sessions', only: [:new, :create, :show]

  # Subjects
  resources :subjects, only: [:new, :create]

  # Tutors
  resources :tutors, only: [:index, :show]

  # Sessions
  resources :sessions, only: [:show, :update] do
    collection do
      get :search
      get :results
    end
    member do
      get :confirm
      post :book
    end
  end
end

