require "test_helper"

class EmptyLegsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get empty_legs_index_url
    assert_response :success
  end
end
