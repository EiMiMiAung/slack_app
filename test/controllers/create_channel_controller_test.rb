require 'test_helper'

class CreateChannelControllerTest < ActionDispatch::IntegrationTest
  test "should get createchannel" do
    get create_channel_createchannel_url
    assert_response :success
  end

end
