require "test_helper"

class SpotUpdateRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get spot_update_requests_create_url
    assert_response :success
  end
end
