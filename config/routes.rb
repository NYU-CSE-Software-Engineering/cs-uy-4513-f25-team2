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

  # Subjects
  resources :subjects, only: [:new, :create]
end
