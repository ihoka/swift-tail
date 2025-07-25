class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :from
      t.string :to
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
