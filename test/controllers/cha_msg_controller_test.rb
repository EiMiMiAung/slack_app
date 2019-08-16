require 'test_helper'

class ChaMsgControllerTest < ActionDispatch::IntegrationTest
  test "should get cha_msg" do
    get cha_msg_cha_msg_url
    assert_response :success
  end

end
