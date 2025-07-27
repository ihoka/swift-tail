class CreateSuperUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :super_users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :super_users, :email, unique: true
  end
end
