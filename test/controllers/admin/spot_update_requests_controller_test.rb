require "test_helper"

class Admin::SpotUpdateRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get admin_spot_update_requests_update_url
    assert_response :success
  end
end
