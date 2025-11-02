require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get mypage" do
    get users_mypage_url
    assert_response :success
  end

  test "should get edit_mypage" do
    get users_edit_mypage_url
    assert_response :success
  end
end
