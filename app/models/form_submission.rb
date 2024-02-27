class FormSubmission < ApplicationRecord
  belongs_to :dentist
  belongs_to :patient
  belongs_to :lab
  belongs_to :form
end
