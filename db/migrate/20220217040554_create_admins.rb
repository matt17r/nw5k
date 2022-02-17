class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email
      t.string :password_digest, null: false
      t.string :remember_token, null: false

      t.timestamps
    end
    add_index :admins, :email
  end
end
