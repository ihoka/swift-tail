require "test_helper"

class AirportTest < ActiveSupport::TestCase
  test "should create airport with factory" do
    airport = create(:airport)
    assert airport.persisted?
    assert airport.valid?
  end

  test "should validate presence of name" do
    airport = build(:airport, name: nil)
    refute airport.valid?
    assert_includes airport.errors[:name], "can't be blank"
  end

  test "should validate presence of icao_code" do
    airport = build(:airport, icao_code: nil)
    refute airport.valid?
    assert_includes airport.errors[:icao_code], "can't be blank"
  end

  test "should validate uniqueness of icao_code" do
    create(:airport, icao_code: "TEST")
    airport = build(:airport, icao_code: "TEST")
    refute airport.valid?
    assert_includes airport.errors[:icao_code], "has already been taken"
  end

  test "should normalize codes before validation" do
    airport = create(:airport, icao_code: "test", iata_code: "ts")
    assert_equal "TEST", airport.icao_code
    assert_equal "TS", airport.iata_code
  end

  test "should work with different traits" do
    large_airport = create(:airport, :large_airport)
    assert_equal "large_airport", large_airport.type

    small_airport = create(:airport, :small_airport)
    assert_equal "small_airport", small_airport.type
    refute small_airport.private_jet_capable

    airport_without_iata = create(:airport, :without_iata)
    assert_nil airport_without_iata.iata_code
  end
end
