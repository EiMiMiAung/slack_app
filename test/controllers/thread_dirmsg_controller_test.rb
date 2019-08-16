require 'test_helper'

class ThreadDirmsgControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get thread_dirmsg_new_url
    assert_response :success
  end

end
