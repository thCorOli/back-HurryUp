class CreateLabs < ActiveRecord::Migration[6.1]
  def change
    create_table :labs do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :cnpj

      t.timestamps
    end
  end
end
