require 'test_helper'

class ThreadControllerTest < ActionDispatch::IntegrationTest
  test "should get thread" do
    get thread_thread_url
    assert_response :success
  end

end
