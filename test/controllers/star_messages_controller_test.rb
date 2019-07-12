require 'test_helper'

class StarMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get star_messages_new_url
    assert_response :success
  end

end
