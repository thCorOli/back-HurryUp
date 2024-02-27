class CreateFormSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :form_submissions do |t|
      t.references :dentist, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.references :lab, null: false, foreign_key: true
      t.references :form, null: false, foreign_key: true
      t.json :data

      t.timestamps
    end
  end
end
