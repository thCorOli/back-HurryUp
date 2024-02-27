class CreateDentists < ActiveRecord::Migration[6.1]
  def change
    create_table :dentists do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :cpf
      t.date :birthday

      t.timestamps
    end
  end
end
