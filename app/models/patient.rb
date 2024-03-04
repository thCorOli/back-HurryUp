class Patient < ApplicationRecord
  belongs_to :dentist
  has_many :form_submissions
  #validates :cpf, uniqueness: { message: " já está em uso ou é inválido." }, format: { with: /\A\d{11}\z/, message: "CPF já está em uso ou é inválido" }
  #validates :email, uniqueness: { message: " já está em uso ou é inválido." }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "E-mail já está em uso ou é inválido" }
end
