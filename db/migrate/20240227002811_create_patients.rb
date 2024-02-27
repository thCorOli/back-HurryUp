class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :email
      t.string :cpf
      t.date :birthday
      t.references :dentist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
