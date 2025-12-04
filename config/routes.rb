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

  # Tutors
  resources :tutors, only: [:index, :show]

  # Sessions (tutor sessions for search / booking / attendance)
  resources :sessions, only: [:new, :create, :show, :update] do
    collection do
      get :search
      get :results
    end
    member do
      get :confirm
      post :book
    end
  end

  # Learner's booked sessions (upcoming, past, and cancellation)
  resources :learner_sessions, only: [:index] do
    collection do
      get :past
    end

    member do
      get  :cancel
      patch :confirm_cancel
    end
  end

  # Learner feedback on sessions
  resources :feedbacks, only: [:new, :create]

  # Tutor feedbacks
  namespace :tutor do
    resources :feedbacks, only: [:index]
  end


  # Tutor's booked sessions (upcoming and past)
  resources :tutor_sessions, only: [:index] do
    collection do
      get :past
    end
    member do
      get :cancel
      patch :confirm_cancel
    end
  end
end