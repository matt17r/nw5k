class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners do |t|
      t.string :title, null: false
      t.string :body
      t.datetime :publish_at, null: false
      t.datetime :withdraw_at, null: false

      t.timestamps
    end
    add_index :banners, :publish_at
    add_index :banners, :withdraw_at
  end
end
