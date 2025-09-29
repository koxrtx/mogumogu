require "test_helper"

class MapsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get maps_search_url
    assert_response :success
  end
end
