require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "should get invitemember" do
    get invitations_invitemember_url
    assert_response :success
  end

end
