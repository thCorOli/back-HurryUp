Rails.application.routes.draw do
  scope :api do
    post '/dentists/login', to: 'dentists#login'
    resources :dentists, only: [:create, :show, :update, :destroy] do
      post '/register_patients', to: 'dentists#create_patient'
      get '/patients', to: 'dentists#list_patients'
      post '/form_submissions', to: 'dentists#submit_form'
      get '/patients/:patient_id', to: 'dentists#show_patient'
      get '/list_labs', to: 'dentists#list_labs', on: :collection
      get '/list_form_submissions', to: 'dentists#list_form_submissions', on: :member
    end

    # Rotas para Labs
    post '/labs/login', to: 'labs#login'
    resources :labs, only: [:create, :show, :update, :destroy] do
      post '/form_submissions/:form_submission_id/feedback', to: 'labs#provide_feedback'
      get '/list_form_submissions', on: :member, to:'labs#get_form_submissions'
      get '/form_submissions/:form_submission_id/patient', to: 'labs#get_lab_patient'
      get '/patients/:patient_id/form_submissions', to: 'labs#get_patient_form_submissions'
    end
  end
end
