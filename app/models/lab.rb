class Lab < ApplicationRecord
    has_many :form_submissions
    has_secure_password
    validates :cnpj, uniqueness: { message: " já está em uso ou é inválido." }
    validates :email, uniqueness: { message: " já está em uso ou é inválido." }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "E-mail já está em uso ou é inválido" }

end
