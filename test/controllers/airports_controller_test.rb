require "test_helper"

class AirportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index without query parameter" do
    airports = create_list(:airport, 3)
    
    get airports_url
    assert_response :success
    
    # Should render HTML with airport options
    assert_select "el-option", count: 3
    
    airports.each do |airport|
      assert_select "el-option[value='#{airport.iata_code}']" do
        assert_select "div.font-medium", text: airport.name
        assert_select "div.text-gray-500", text: "#{airport.iata_code} - #{airport.city}, #{airport.country}"
      end
    end
  end

  test "should search airports by name" do
    matching_airport = create(:airport, name: "Los Angeles International")
    non_matching_airport = create(:airport, name: "John F Kennedy International")
    
    get airports_url, params: { query: "Angeles" }
    assert_response :success
    
    assert_select "el-option", count: 1
    assert_select "el-option[value='#{matching_airport.iata_code}']" do
      assert_select "div.font-medium", text: matching_airport.name
    end
  end

  test "should search airports by iata code" do
    matching_airport = create(:airport, iata_code: "LAX")
    non_matching_airport = create(:airport, iata_code: "JFK")
    
    get airports_url, params: { query: "LAX" }
    assert_response :success
    
    assert_select "el-option", count: 1
    assert_select "el-option[value='#{matching_airport.iata_code}']" do
      assert_select "div.font-medium", text: matching_airport.name
    end
  end

  test "should search airports case insensitively" do
    matching_airport = create(:airport, iata_code: "LAX")
    
    get airports_url, params: { query: "lax" }
    assert_response :success
    
    assert_select "el-option", count: 1
    assert_select "el-option[value='#{matching_airport.iata_code}']" do
      assert_select "div.font-medium", text: matching_airport.name
    end
  end

  test "should limit results to 7 airports" do
    create_list(:airport, 10)
    
    get airports_url
    assert_response :success
    
    assert_select "el-option", count: 7
  end

  test "should return empty result when no matches found" do
    create(:airport, name: "Test Airport", iata_code: "TST")
    
    get airports_url, params: { query: "NONEXISTENT" }
    assert_response :success
    
    assert_select "el-option", count: 0
  end

  test "should handle empty query parameter" do
    airports = create_list(:airport, 3)
    
    get airports_url, params: { query: "" }
    assert_response :success
    
    assert_select "el-option", count: 3
  end

  test "should handle whitespace-only query parameter" do
    airports = create_list(:airport, 3)
    
    get airports_url, params: { query: "   " }
    assert_response :success
    
    assert_select "el-option", count: 3
  end
end