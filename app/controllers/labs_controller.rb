# app/controllers/labs_controller.rb
require 'jwt'
class LabsController < ApplicationController
    before_action :set_lab, only: [:show, :update, :destroy]
  
    # POST /labs/login
    def login
      # Acesse os parâmetros dentro do objeto lab
      @lab = Lab.find_by(email: params[:lab][:email])
      
      if @lab && @lab.authenticate(params[:lab][:password])
        token = generate_token(@lab)
        render json: { lab: @lab, token: token }, status: :ok
      else
        render json: { error: 'Email ou senha inválida' }, status: :unauthorized
      end
    end

    def generate_token(lab)
      JWT.encode({ lab_id: lab.id }, 'secret_key', 'HS256')
    end
  
    # POST /labs
    def create
      @lab = Lab.new(lab_params)
  
      if @lab.save
        render json: @lab, status: :created
      else
        render json: @lab.errors, status: :unprocessable_entity
      end
    end
  
    # POST /labs/:lab_id/form_submissions/:form_submission_id/feedback
    def provide_feedback
      @lab = Lab.find(params[:lab_id])
      @form_submission = @lab.form_submissions.find(params[:form_submission_id])
  
      if @form_submission.update(feedback_params)
        render json: @form_submission
      else
        render json: @form_submission.errors, status: :unprocessable_entity
      end
    end

    # GET /labs/:lab_id/form_submissions
    def get_form_submissions
      @lab = Lab.find(params[:id])
      @form_submissions = @lab.form_submissions

      render json: @form_submissions
    end
  
      # GET /labs/:lab_id/patients/:patient_id
      def get_lab_patient
        @lab = Lab.find(params[:lab_id])
        @form_submission = @lab.form_submissions.find(params[:form_submission_id])
        @patient_id = @form_submission.patient_id
        @patient = Patient.find(@patient_id)
      
        render json: @patient
      end

      # GET /labs/:lab_id/patients/:patient_id/form_submissions
      def get_patient_form_submissions
        @lab = Lab.find(params[:lab_id])
        @patient = Patient.find(params[:patient_id])
        @form_submissions = @lab.form_submissions.where(patient_id: @patient.id)

        render json: @form_submissions
      end

      private
        def set_lab
          @lab = Lab.find(params[:id])
        end
  
        def lab_params
          params.require(:lab).permit(:name, :email, :password, :cnpj)
        end
  
        def feedback_params
          params.require(:form_submission).permit(:feedback)
        end

        def authenticate_token
          token = request.headers['Authorization']
          if token
            begin
              decoded_token = JWT.decode(token, 'secret_key', true, algorithm: 'HS256')
              dentist_id = decoded_token.first['dentist_id']
              @current_dentist = Dentist.find(dentist_id)
            rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
              render json: { error: 'Token inválido ou expirado' }, status: :unauthorized
            end
          else
            render json: { error: 'Token não encontrado' }, status: :unauthorized
          end
    end
end
  