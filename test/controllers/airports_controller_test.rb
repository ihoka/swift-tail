require "test_helper"

class AirportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index without query parameter" do
    airports = create_list(:airport, 3)
    
    get airports_url
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 3, json_response.length
    
    airport = json_response.first
    assert_includes airport.keys, "id"
    assert_includes airport.keys, "name"
    assert_includes airport.keys, "iata_code"
    assert_includes airport.keys, "icao_code"
    assert_includes airport.keys, "city"
    assert_includes airport.keys, "country"
  end

  test "should search airports by name" do
    matching_airport = create(:airport, name: "Los Angeles International")
    non_matching_airport = create(:airport, name: "John F Kennedy International")
    
    get airports_url, params: { query: "Angeles" }
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
    assert_equal matching_airport.id, json_response.first["id"]
  end

  test "should search airports by iata code" do
    matching_airport = create(:airport, iata_code: "LAX")
    non_matching_airport = create(:airport, iata_code: "JFK")
    
    get airports_url, params: { query: "LAX" }
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
    assert_equal matching_airport.id, json_response.first["id"]
  end

  test "should search airports case insensitively" do
    matching_airport = create(:airport, iata_code: "LAX")
    
    get airports_url, params: { query: "lax" }
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
    assert_equal matching_airport.id, json_response.first["id"]
  end

  test "should limit results to 7 airports" do
    create_list(:airport, 10)
    
    get airports_url
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 7, json_response.length
  end

  test "should return empty array when no matches found" do
    create(:airport, name: "Test Airport", iata_code: "TST")
    
    get airports_url, params: { query: "NONEXISTENT" }
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 0, json_response.length
  end

  test "should handle empty query parameter" do
    airports = create_list(:airport, 3)
    
    get airports_url, params: { query: "" }
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 3, json_response.length
  end

  test "should handle whitespace-only query parameter" do
    airports = create_list(:airport, 3)
    
    get airports_url, params: { query: "   " }
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 3, json_response.length
  end
end