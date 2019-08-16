require 'test_helper'

class RefreshControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get refresh_new_url
    assert_response :success
  end

end
