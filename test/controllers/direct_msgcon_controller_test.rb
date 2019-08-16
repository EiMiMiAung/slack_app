require 'test_helper'

class DirectMsgconControllerTest < ActionDispatch::IntegrationTest
  test "should get direct_msgcon" do
    get direct_msgcon_direct_msgcon_url
    assert_response :success
  end

end
