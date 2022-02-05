class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :nickname
      t.string :emoji
      t.string :password_digest, null: false
      t.string :remember_token, null: false
      t.date :birthdate
      t.string :country
      t.string :parkrun_id

      t.timestamps
    end
    add_index :people, :email
    add_index :people, :nickname
    add_index :people, :remember_token, unique: true
    add_index :people, :parkrun_id
  end
end
