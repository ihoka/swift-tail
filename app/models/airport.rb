# app/models/airport.rb
class Airport < ApplicationRecord
  validates :name, presence: true
  validates :icao_code, presence: true, uniqueness: true
  validates :iata_code, uniqueness: true, allow_nil: true

  scope :private_jet_capable, -> { where(private_jet_capable: true) }
  scope :by_country, ->(code) { where(country_code: code) }
  scope :major_airports, -> { where(type: %w[large_airport medium_airport]) }

  before_validation :normalize_codes

  private

  def normalize_codes
    self.iata_code = iata_code&.upcase&.strip
    self.icao_code = icao_code&.upcase&.strip
  end
end
