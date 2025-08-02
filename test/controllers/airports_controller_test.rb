require "test_helper"

class AirportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index without query parameter" do
    private_jet_airports = create_list(:airport, 3)
    non_private_jet_airports = create_list(:airport, 2, :small_airport)
    
    get airports_url
    assert_response :success
    
    # Should render HTML with airport options - only private jet capable airports
    assert_select "el-option", count: 3
    
    private_jet_airports.each do |airport|
      assert_select "el-option[value='#{airport.iata_code}']" do
        assert_select "div.font-medium", text: airport.name
        assert_select "div.text-gray-500", text: "#{airport.iata_code} - #{airport.city}, #{airport.country}"
      end
    end
  end

  test "should search airports by name" do
    matching_airport = create(:airport, name: "Los Angeles International")
    non_matching_airport = create(:airport, name: "John F Kennedy International")
    non_private_jet_airport = create(:airport, :small_airport, name: "Angeles Small Airport")
    
    get airports_url, params: { query: "Angeles" }
    assert_response :success
    
    # Should only return the private jet capable airport that matches
    assert_select "el-option", count: 1
    assert_select "el-option[value='#{matching_airport.iata_code}']" do
      assert_select "div.font-medium", text: matching_airport.name
    end
  end

  test "should search airports by iata code" do
    matching_airport = create(:airport, iata_code: "LAX")
    non_matching_airport = create(:airport, iata_code: "JFK")
    non_private_jet_airport = create(:airport, :small_airport, iata_code: "LAS")
    
    get airports_url, params: { query: "LAX" }
    assert_response :success
    
    # Should only return the private jet capable airport that matches
    assert_select "el-option", count: 1
    assert_select "el-option[value='#{matching_airport.iata_code}']" do
      assert_select "div.font-medium", text: matching_airport.name
    end
  end

  test "should search airports case insensitively" do
    matching_airport = create(:airport, iata_code: "LAX")
    non_private_jet_airport = create(:airport, :small_airport, iata_code: "LAS")
    
    get airports_url, params: { query: "lax" }
    assert_response :success
    
    # Should only return the private jet capable airport that matches
    assert_select "el-option", count: 1
    assert_select "el-option[value='#{matching_airport.iata_code}']" do
      assert_select "div.font-medium", text: matching_airport.name
    end
  end

  test "should limit results to 7 airports" do
    create_list(:airport, 10)
    create_list(:airport, 5, :small_airport)
    
    get airports_url
    assert_response :success
    
    # Should limit to 7 private jet capable airports only
    assert_select "el-option", count: 7
  end

  test "should return empty result when no matches found" do
    create(:airport, name: "Test Airport", iata_code: "TST")
    create(:airport, :small_airport, name: "Non Private Jet Airport", iata_code: "NPJ")
    
    get airports_url, params: { query: "NONEXISTENT" }
    assert_response :success
    
    assert_select "el-option", count: 0
  end

  test "should handle empty query parameter" do
    private_jet_airports = create_list(:airport, 3)
    non_private_jet_airports = create_list(:airport, 2, :small_airport)
    
    get airports_url, params: { query: "" }
    assert_response :success
    
    # Should return all private jet capable airports, not the small airports
    assert_select "el-option", count: 3
  end

  test "should handle whitespace-only query parameter" do
    private_jet_airports = create_list(:airport, 3)
    non_private_jet_airports = create_list(:airport, 2, :small_airport)
    
    get airports_url, params: { query: "   " }
    assert_response :success
    
    # Should return all private jet capable airports, not the small airports
    assert_select "el-option", count: 3
  end

  test "should exclude non-private jet capable airports from search results" do
    private_jet_airport = create(:airport, name: "Private Jet Airport", iata_code: "PJA")
    non_private_jet_airport = create(:airport, :small_airport, name: "Small Airport", iata_code: "SMA")
    
    get airports_url, params: { query: "Airport" }
    assert_response :success
    
    # Should only return the private jet capable airport
    assert_select "el-option", count: 1
    assert_select "el-option[value='#{private_jet_airport.iata_code}']" do
      assert_select "div.font-medium", text: private_jet_airport.name
    end
  end
end