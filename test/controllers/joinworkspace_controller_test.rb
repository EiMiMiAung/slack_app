require 'test_helper'

class JoinworkspaceControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get joinworkspace_edit_url
    assert_response :success
  end

end
