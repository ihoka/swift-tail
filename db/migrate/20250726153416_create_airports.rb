class CreateAirports < ActiveRecord::Migration[8.0]
  def change
    create_table :airports do |t|
      t.string :iata_code, limit: 3, index: true
      t.string :icao_code, limit: 10, index: true
      t.string :name, null: false
      t.string :city
      t.string :country
      t.string :country_code, limit: 2
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :elevation_ft
      t.string :type # airport, heliport, seaplane_base
      t.boolean :private_jet_capable, default: false
      t.string :timezone
      t.text :runways_info # JSON string for runway details

      t.timestamps
    end

    add_index :airports, [ :latitude, :longitude ]
    add_index :airports, :private_jet_capable
  end
end
