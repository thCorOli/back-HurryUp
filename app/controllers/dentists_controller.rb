# app/controllers/dentists_controller.rb
require 'jwt'
class DentistsController < ApplicationController
    before_action :set_dentist, only: [:show, :update, :destroy]
    wrap_parameters false

    def login
      # Acesse os parâmetros dentro do objeto dentist
      @dentist = Dentist.find_by(email: params[:dentist][:email])
      
      if @dentist && @dentist.authenticate(params[:dentist][:password])
        token = generate_token(@dentist)
        render json: { dentist: @dentist, token: token, allowed: @dentist.present? }, status: :ok
      else
        render json: { error: 'Email ou senha inválida' }, status: :unauthorized
      end
    end

    def generate_token(dentist)
      JWT.encode({ dentist_id: dentist.id }, 'secret_key', 'HS256')
    end
    

    def create
      @dentist = Dentist.new(dentist_params)
  
      if @dentist.save
        render json: @dentist, status: :created
      else
        render json: @dentist.errors, status: :unprocessable_entity
      end
    end
  
    def create_patient
      @dentist = Dentist.find(params[:dentist_id])
      @patient = @dentist.patients.build(patient_params)
      
  
      if @patient.save
        render json: @patient, status: :created
      else
        render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def list_patients
      @dentist = Dentist.find(params[:dentist_id])
      render json: @dentist.patients
    end
  
    def submit_form
      @dentist = Dentist.find(params[:dentist_id])
      @form_submission = @dentist.form_submissions.build(form_submission_params)
      Rails.logger.debug("Params recebidos: #{params.inspect}")
      Rails.logger.debug("Dentista encontrado: #{@dentist}")
      
      if @form_submission.save
        render json: @form_submission, status: :created
      else
        Rails.logger.error("Erro ao salvar o formulário de submissão: #{@form_submission.errors}")
        render json: @form_submission.errors, status: :unprocessable_entity
      end
    end
    
    def show_patient
      @dentist = Dentist.find(params[:dentist_id])
      @patient = @dentist.patients.find(params[:patient_id])
      @form_submissions = @patient.form_submissions
      render json: { patient: @patient, form_submissions: @form_submissions }
    end
    
    def forgot_password
      if params[:email].blank?
          return render json: {error: 'Email inválido'}, status: :unprocessable_entity
      end
      @patient = Patient.find_by_email(params[:email])
      puts @patient
      if @patient.present?
          puts "user: #{@patient.password_digest}"
          @patient.generate_password_token!
          UserMailer.forgot_password(@patient).deliver_now
          render json: {}, status: :ok
      else
          render json: {error: ['Email não encontrado.']}, status: :unprocessable_entity
      end
  end

  def reset_password
      @patient = Patient.find_by_reset_password_token(params[:token])
      if @patient.present? && @patient.password_token_valid?
          if @patient.reset_password!(params[:password], params[:password_confirmation])
              render json: {}, status: :ok
          else
              render json: {error: @patient.errors.full_messages}, status: :unprocessable_entity
          end
      else
          render json: {error: ['Link inválido ou expirado, tente gerar um novo link']}, status: :unauthorized
      end
  end

  def list_labs
    @labs = Lab.all
    render json: @labs
  end

  def list_form_submissions
    @patient = Patient.find(params[:patient_id])
    @form_submissions = @patient.form_submissions
    render json: @form_submissions, methods: [:files]
  end
  
  private
    def set_dentist
      @dentist = Dentist.find(params[:id])
    end

    def dentist_params
      params.require(:dentist).permit(:name, :email, :password, :cpf, :birthday)
    end

    def patient_params
      params.require(:patient).permit(:name, :email, :cpf, :birthday, :prontuario)
    end

    def form_submission_params
      params.require(:form_submission).permit(:files, :patient_id, :lab_id, :form_id, :dentist_id, form_values: {})
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

  