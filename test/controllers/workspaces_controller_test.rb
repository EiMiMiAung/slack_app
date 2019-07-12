require 'test_helper'

class WorkspacesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get workspaces_new_url
    assert_response :success
  end

end
