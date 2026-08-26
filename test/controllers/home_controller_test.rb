require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "home is reachable" do
    get root_path
    assert_response :success
  end
end
