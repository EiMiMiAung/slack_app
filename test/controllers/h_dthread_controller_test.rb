require 'test_helper'

class HDthreadControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get h_dthread_new_url
    assert_response :success
  end

end
