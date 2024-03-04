class Dentist < ApplicationRecord
    has_many :patients
    has_many :form_submissions
    has_secure_password
    validates :cpf, uniqueness: true
    validates :email, uniqueness: true
end
