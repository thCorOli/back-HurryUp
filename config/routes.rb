Rails.application.routes.draw do
  scope :api do
    # Rotas para Dentists
    post '/dentists/login', to: 'dentists#login'
    resources :dentists, only: [:create, :show, :update, :destroy] do
      post '/register_patients', to: 'dentists#create_patient'
      get '/patients', to: 'dentists#list_patients'
      post '/form_submissions', to: 'dentists#submit_form'
      get '/patients/:patient_id', to: 'dentists#show_patient'
    end

    # Rotas para Labs
    post '/labs/login', to: 'labs#login'
    resources :labs, only: [:create, :show, :update, :destroy] do
      post '/form_submissions/:form_submission_id/feedback', to: 'labs#provide_feedback'
    end
  end
end
