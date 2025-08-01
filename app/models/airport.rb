# app/models/airport.rb
class Airport < ApplicationRecord
  self.inheritance_column = nil

  validates :name, presence: true
  validates :icao_code, presence: true, uniqueness: true
  validates :iata_code, uniqueness: true, allow_nil: true

  scope :private_jet_capable, -> { where(private_jet_capable: true) }
  scope :by_iata_code, ->(iata_code) { find_by(iata_code: iata_code&.upcase&.strip) }
  scope :major_airports, -> { where(type: %w[large_airport medium_airport]) }
  scope :search, ->(query) { where("name ILIKE ? OR iata_code ILIKE ?", "%#{query}%", "%#{query}%") }

  before_validation :normalize_codes

  private

  def normalize_codes
    self.iata_code = iata_code&.upcase&.strip
    self.icao_code = icao_code&.upcase&.strip
  end
end
