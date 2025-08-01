require "test_helper"

class EmptyLegsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get empty_leg_near_me_url
    assert_response :success
  end

  test "should redirect to root if airport not found" do
    get airport_empty_legs_url(iata_code: "XYZ")
    assert_redirected_to root_path
    assert_equal "Airport not found", flash[:alert]
  end

  test "should get empty legs by airport" do
    airport = create(:airport, iata_code: "JFK")
    get airport_empty_legs_url(iata_code: airport.iata_code)
    assert_response :success
    assert_select "p", text: airport.iata_code
  end
end
